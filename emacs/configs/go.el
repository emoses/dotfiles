(use-package go-mode
  :mode "\\.go$"
  :bind (:map go-mode-map
              ("C-c C-c" . compile)
              ;; This overrides godef-describe
              ("C-c C-d" . my:godoc-maybe-at-point)
              ("C-c d" . godef-describe))
  :config
  (add-hook 'go-mode-hook #'lsp)
  (add-hook 'go-mode-hook (lambda ()
                            (progn
                              (ivy-mode t)
                              (add-hook 'before-save-hook #'maybe-lsp-format-buffer t t)
                              (add-hook 'before-save-hook #'maybe-lsp-organize-imports t t)
                              (set (make-local-variable 'compile-command) "go build")
                              (set (make-local-variable 'yas-ident-line) 'fixed)
                              (set (make-local-variable 'compilation-skip-threshold) 2))))

  (defun maybe-lsp-format-buffer ()
    (when (lsp-workspaces)
      (condition-case nil
          (lsp-format-buffer)
        (lsp-capability-not-supported nil))))

  (defun maybe-lsp-organize-imports ()
    (when (lsp-workspaces)
      (lsp-organize-imports)))

  (defun my:godoc-maybe-at-point (lookup-at-point)
    (interactive "P")
    (if lookup-at-point
        (call-interactively #'godoc-at-point)
      (call-interactively #'godoc)))

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
