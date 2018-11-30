(use-package pyenv-mode
  :ensure t)

(eval-after-load 'python-mode
  (progn
                                        ; extracted from elpy
    (defun my:python-occur-definitions ()
      "Display an occur buffer of all definitions in the current buffer.
Also, switch to that buffer."
      (interactive)
      (let ((list-matching-lines-face nil))
        (occur "^\s*\\(\\(async\s\\|\\)def\\|class\\)\s"))
      (let ((window (get-buffer-window "*Occur*")))
        if window
        (select-window window)

        (switch-to-buffer "*Occur*")))
    (defun my:projectile-ag-symbol (search-term &optional arg)
      "Run an ag search for symbol at point, or region if active.

With optional prefix ARG, SEARCH-TERM is treated as a regexp"
      (interactive
       (list
        (let ((symbol
               (if (use-region-p)
                   (buffer-substring-no-properties (region-beginning)
                                                   (region-end))
                 (thing-at-point 'symbol))))
          (if (and symbol (not current-prefix-arg))
              symbol
            (projectile--read-search-string-with-default
             (format "Search in project for %s: " (if current-prefix-arg "regexp" "string")))))
        current-prefix-arg))
      (projectile-ag search-term arg))
    (define-key python-mode-map (kbd "C-c C-o") #'my:python-occur-definitions)
    (define-key python-mode-map (kbd "C-c C-s") #'my:projectile-ag-symbol)

    ;; (add-hook 'python-mode-hook 'flycheck-mode)
    ))

;; (use-package elpy
;;   :ensure t
;;   :after flycheck
;;   :mode ("\\.py$" . python-mode)
;;   :bind (:map elpy-mode-map
;;               ;; ("M-/" . elpy-goto-definition)
;;               ("C-c C-r f" . elpy-autopep8-fix-code))
;;   :init
;;   (pyenv-mode)
;;   (elpy-enable)
;;   :config
;;   (setq elpy-rpc-python-command "python3")
;;   (setq python-shell-interpreter "python3")
;;   (setq elpy-modules (cl-set-difference elpy-modules
;;                                         '('elpy-module-flymake 'elpy-module-company 'elpy-module-eldoc)))
;;   (add-hook 'elpy-mode-hook 'flycheck-mode))

(use-package lsp-mode
  :ensure t
  :after el-patch
  :config

  ;; change nil to 't to enable logging of packets between emacs and the LS
  ;; this was invaluable for debugging communication with the MS Python Language Server
  ;; and comparing this with what vs.code is doing




  (setq lsp-print-io nil)
  (defun my:lsp--filter-variables (filter-fn sym)
    (if (= 13 (gethash "kind" sym))
        (progn
          (message "found var")
          nil)
      (funcall filter-fn sym)))
  (advice-add 'lsp--symbol-filter :around #'my:lsp--filter-variables)

  ;; lsp-ui gives us the blue documentation boxes and the sidebar info
  (use-package lsp-ui
    :ensure t
    :config
    (setq lsp-ui-sideline-ignore-duplicate t)
    (setq lsp-ui-sideline-enable nil)
    (add-hook 'lsp-mode-hook 'lsp-ui-mode)
    (add-hook 'lsp-ui-imenu-mode-hook (lambda () (display-line-numbers-mode -1)))
    :config/el-patch
    ;; cpbotha: with numpy functions, e.g. np.array for example,
    ;; kind=markdown and docs are in markdown, but in default
    ;; lsp-ui-20181031 this is rendered as plaintext see
    ;; https://microsoft.github.io/language-server-protocol/specification#markupcontent
s
    ;; not only that, MS PyLS turns all spaces into &nbsp; instances,
    ;; which we remove here this single additional cond clause fixes all
    ;; of this for hover

    ;; as if that was not enough: import pandas as pd - pandas is returned
    ;; with kind plaintext but contents markdown, whereas pd is returned
    ;; with kind markdown. fortunately, handling plaintext with the
    ;; markdown viewer still looks good, so here we are.
    (defun lsp-ui-doc--extract (contents)
      "Extract the documentation from CONTENTS.
CONTENTS can be differents type of values:
MarkedString | MarkedString[] | MarkupContent (as defined in the LSP).
We don't extract the string that `lps-line' is already displaying."
      (when contents
        (cond
         ((stringp contents) contents)
         ((sequencep contents) ;; MarkedString[]
          (mapconcat 'lsp-ui-doc--extract-marked-string
                     (lsp-ui-doc--filter-marked-string contents)
                     "\n\n"
                     ;; (propertize "\n\n" 'face '(:height 0.4))
                     ))
         (el-patch-add
           ((member (gethash "kind" contents) '("markdown" "plaintext"))
            (replace-regexp-in-string "&nbsp;" " " (lsp-ui-doc--extract-marked-string contents))))
         ((gethash "kind" contents) (gethash "value" contents)) ;; MarkupContent
         ((gethash "language" contents) ;; MarkedString
          (lsp-ui-doc--extract-marked-string contents))))))

  ;; make sure we have lsp-imenu everywhere we have LSP
  (require 'lsp-imenu)
  (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)

  ;; install LSP company backend for LSP-driven completion
  (use-package company-lsp
    :after company-mode
    :ensure t
    :config
    (push 'company-lsp company-backends))

  ;; dir containing Microsoft.Python.LanguageServer.dll
  (setq ms-pyls-dir (expand-file-name "~/dev/python-language-server/output/bin/Release/"))

  ;; this gets called when we do lsp-describe-thing-at-point in lsp-methods.el
  ;; we remove all of the "&nbsp;" entities that MS PYLS adds
  ;; this is mostly harmless for other language servers
  (defun render-markup-content (kind content)
    (message kind)
    (replace-regexp-in-string "&nbsp;" " " content))
  (setq lsp-render-markdown-markup-content #'render-markup-content)

  ;; it's crucial that we send the correct Python version to MS PYLS, else it returns no docs in many cases
  ;; furthermore, we send the current Python's (can be virtualenv) sys.path as searchPaths
  (defun get-python-ver-and-syspath (workspace-root)
    "return list with pyver-string and json-encoded list of python search paths."
    (let ((python (executable-find python-shell-interpreter))
          (init "from __future__ import print_function; import sys; import json;")
          (ver "print(\"%s.%s\" % (sys.version_info[0], sys.version_info[1]));")
          (sp (concat "sys.path.insert(0, '" workspace-root "'); print(json.dumps(sys.path))")))
      (with-temp-buffer
        (call-process python nil t nil "-c" (concat init ver sp))
        (subseq (split-string (buffer-string) "\n") 0 2))))

  ;; I based most of this on the vs.code implementation:
  ;; https://github.com/Microsoft/vscode-python/blob/master/src/client/activation/languageServer/languageServer.ts#L219
  ;; (it still took quite a while to get right, but here we are!)
  (defun ms-pyls-extra-init-params (workspace)
    (destructuring-bind (pyver pysyspath) (get-python-ver-and-syspath (lsp--workspace-root workspace))
      `(:interpreter (
                      :properties (
                                   :InterpreterPath ,(executable-find python-shell-interpreter)
                                   :DatabasePath ,ms-pyls-dir
                                   :Version ,pyver))
                     ;; preferredFormat "markdown" or "plaintext"
                     ;; experiment to find what works best -- over here mostly plaintext
                     :displayOptions (
                                      :preferredFormat "plaintext"
                                      :trimDocumentationLines :json-false
                                      :maxDocumentationLineLength 0
                                      :trimDocumentationText :json-false
                                      :maxDocumentationTextLength 0)
                     :searchPaths ,(json-read-from-string pysyspath))))

  (lsp-define-stdio-client lsp-python "python"
                           #'ffip-get-project-root-directory
                           `("dotnet" ,(concat ms-pyls-dir "Microsoft.Python.LanguageServer.dll"))
                           :extra-init-params #'ms-pyls-extra-init-params)

  ;; lsp-python-enable is created by macro above
  (add-hook 'python-mode-hook
            (lambda ()
              (lsp-python-enable))))
