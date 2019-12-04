(use-package go-mode
  :mode "\\.go$"
  :bind ([C-c C-c] . compile)
  :config
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-hook 'go-mode-hook (lambda ()
          (set (make-local-variable 'compile-command) "go build"))))

(use-package company-go
  :after (company go-mode))
