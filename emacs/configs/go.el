(use-package go-mode
  :mode "\\.go$"
  :bind (("C-c C-c" . compile))
  :config
  (add-hook 'go-mode-hook #'lsp)
  (add-hook 'go-mode-hook (lambda ()
                            (progn
                              (ivy-mode t)
                              (add-hook 'before-save-hook #'lsp-format-buffer t t)
                              (add-hook 'before-save-hook #'lsp-organize-imports t t)
                              (set (make-local-variable 'compile-command) "go build")
                              (set (make-local-variable 'yas-ident-line) 'fixed))))

  (defun go-compile-for-test-debug ()
    (interactive)
    (let ((compile-command "go test -c -gcflags \"all=-N -l\""))
      (call-interactively #'compile)))

  (defun go-lineify-arguments ()
    "TODO: make idempotent, handle more errors"
    (interactive)
    (when (python-syntax-comment-or-string-p)
      (error "Cannot use this function inside a string or comment"))
    (save-excursion
      ( while)
      (sp-up-sexp)
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
        (newline-and-indent)))) )

(use-package go-dlv)

(use-package gotest)
