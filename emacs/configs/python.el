(use-package pyenv-mode)

(eval-after-load 'python-mode
  (progn
                                        ; extracted from elpy
    (pyenv-mode)
    (setq python-shell-interpreter "python3")
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
    (define-key pyenv-mode-map (kbd "C-c C-s") nil)
    (define-key python-mode-map (kbd "C-c C-o") #'my:python-occur-definitions)
    (define-key python-mode-map (kbd "C-c C-s") #'my:projectile-ag-symbol)
    (unbind-key (kbd "C-c C-p") python-mode-map) ;Unbind run-python, which is easy to mis-hit with projectile
    (set-variable 'python-indent-def-block-scale 1)

    ;; (add-hook 'python-mode-hook 'flycheck-mode)
    ))

;; (use-package elpy
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
  :bind (("C-c M-r" . lsp-rename))
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
    :config
    (setq lsp-ui-sideline-ignore-duplicate t)
    (setq lsp-ui-sideline-enable nil)
    (add-hook 'lsp-mode-hook 'lsp-ui-mode)
    (add-hook 'lsp-ui-imenu-mode-hook (lambda () (display-line-numbers-mode -1))))

  ;; make sure we have lsp-imenu everywhere we have LSP
;;  (require 'lsp-imenu)
 ;; (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)

  ;; install LSP company backend for LSP-driven completion
  (use-package company-lsp
    :after company-mode
    :config
    (push 'company-lsp company-backends))

  (use-package lsp-python-ms
    ;; :load-path "~/dev/lsp-python-ms/"
    :after (projectile)
    :straight (:host github :repo "emoses/lsp-python-ms")
    :config
    ;; dir containing Microsoft.Python.LanguageServer.dll
    (setq lsp-python-ms-dir (expand-file-name "~/dev/python-language-server/output/bin/Release/")))


  ;; lsp-python-enable is created by macro above
  (add-hook 'python-mode-hook 'lsp))
