(use-package go-mode
  :after (lsp)
  :mode "\\.go$"
  :bind ([C-c C-c] . compile)
  :config
  (defun my:lsp-go-install-save-hooks ())
  (add-hook 'go-mode-hook (lambda ()
                            (add-hook 'before-save-hook #'lsp-format-buffer t t)
                            (add-hook 'before-save-hook #'lsp-organize-imports t t)
                            (set (make-local-variable 'compile-command) "go build")))
  (add-hook 'go-mode-hook #'lsp)
  (lsp--set-configuration))
