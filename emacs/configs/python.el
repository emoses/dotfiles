; (use-package pyenv-mode)

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :after pyenv-mode
  :bind (:map pyenv-mode-map
              ("C-c C-s" . nil)
              :map python-mode-map
              ("C-c C-o" . #'my:python-occur-definitions)
              ("C-c C-s" . #'my:projectile-ag-symbol)
              ("C-c C-a" . #'python-lineify-arguments))
  :config
                                        ; extracted from elpy
  (require 'subr-x)
  (pyenv-mode)
  (setq python-shell-interpreter "python3")
  (defun my:python-occur-definitions ()
    "Display an occur buffer of all definitions in the current buffer.
Also, switch to that buffer."
    (interactive)
    (let ((list-matching-lines-face nil))
      (occur "^\s*\\(\\(async\s\\|\\)def\\|class\\)\s"))
    (when-let ((window (get-buffer-window "*Occur*")))
      (select-window window))
    (switch-to-buffer "*Occur*"))


  (defun python-lineify-arguments ()
    "TODO: make idempotent, handle more errors"
    (interactive)
    (when (python-syntax-comment-or-string-p)
      (error "Cannot use this function inside a string or comment"))
    (save-excursion
      (python-nav-up-list -1)
      (while (not (equal (char-after) ?\)))
        (forward-char)
        (if (not (eolp))
            (newline-and-indent)
          (forward-line))
        (condition-case nil
            (while (not (equal (char-after) ?,))
              (python-nav-forward-sexp))
          (error
           (search-forward ")" nil nil)
           (backward-char))))
      (when (not (equal (char-before) ?,))
        (insert ?,)
        (newline-and-indent))))

  (unbind-key (kbd "C-c C-p") python-mode-map) ;Unbind run-python, which is easy to mis-hit with projectile
  (unbind-key (kbd "C-c C-r") python-mode-map) ; Conflict with my revert-buffer binding
  (set-variable 'python-indent-def-block-scale 1)
  (add-hook 'python-mode-hook 'flycheck-mode))

;; (use-package yapfify
;;   :hook (python-mode . yapf-mode))

(use-package python-pytest
  :straight (:host github :repo "emoses/emacs-python-pytest")
  :after python
  :custom
  (python-pytest-executable "devx pytest")
  (python-pytest-shell-startfile "~/.bashrc")
  (python-pytest-arguments '("--color"))
  :bind (:map python-mode-map
              ("C-c t" . python-pytest-popup)
              ("C-c T" . python-pytest-repeat))
  )

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
(use-package lsp-python-ms
    :after (projectile lsp)
    :init (setq lsp-python-ms-auto-install-server t)
    :config
    ;; dir containing Microsoft.Python.LanguageServer.dll
    ;; (setq lsp-python-ms-server-setings
    ;;       '(:python.analysis.logLevel "info"))
    ;; (setq lsp-python-ms-dir (expand-file-name "~/dev/python-language-server/output/bin/Release/"))
    )

(use-package pyvenv)

(use-package pylint)
