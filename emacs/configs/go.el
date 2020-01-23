(use-package go-mode
  :after (lsp)
  :mode "\\.go$"
  :bind (("C-c C-c" . compile))
  :config
  (add-hook 'go-mode-hook #'lsp)
  (add-hook 'go-mode-hook (lambda ()
                            (progn
                              (add-hook 'before-save-hook #'lsp-format-buffer t t)
                              (add-hook 'before-save-hook #'lsp-organize-imports t t)
                              (set (make-local-variable 'compile-command) "go build")))))

(use-package go-dlv)
