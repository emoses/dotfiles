(use-package go-mode
  :mode "\\.go$"
  :bind (:map go-mode-map
              ("C-c C-c" . compile)
              ;; This overrides godef-describe
              ("C-c C-d" . my:godoc-maybe-at-point)
              ("C-c d" . godef-describe))
  :config
  (defun my:go-mode-hooks ()
    (ivy-mode t)
    (add-hook 'before-save-hook #'maybe-lsp-format-buffer t t)
    (add-hook 'before-save-hook #'maybe-lsp-organize-imports t t)
    ;;this can improperly remove trailing whitespace from multiline strings
    (remove-hook 'before-save-hook #'delete-trailing-whitespace)
    (set (make-local-variable 'compile-command) "go build")
    (set (make-local-variable 'yas-indent-line) 'fixed)
    (set (make-local-variable 'compilation-skip-threshold) 2))

  (defun my:go-local-var-hooks ()
    (when (derived-mode-p 'go-mode)
      (lsp)
      (-flycheck-golangci-lint-setup)))

  (add-hook 'go-mode-hook #'my:go-mode-hooks)
  ;; Instead of adding to go-mode-hook, add lsp to hack-local-variables-hook so the .dir-locals.el is loaded before lsp comes up
  (add-hook 'hack-local-variables-hook #'my:go-local-var-hooks)

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

  (defun go-get-interfaces-in-buffer ()
    (save-excursion
      (goto-char (point-min))
      (let ((interfaces '()))
        (while (re-search-forward "^type *\\([^ \t\n\r\f]*\\) interface" nil t)
          (push (match-string-no-properties 1) interfaces))
        interfaces)))

  (defun go-mock-this ()
    (interactive)
    (let* ((interfaces (go-get-interfaces-in-buffer))
           (mock-interface (completing-read "Interface to mock" interfaces))
           (current-file (file-name-nondirectory (buffer-file-name)))
           (current-dir (file-name-directory (buffer-file-name)))
           (mock-dir (concat current-dir "mocks"))
           (mock-file (concat (file-name-as-directory mock-dir) "mock.go")))
      (unless (file-exists-p mock-dir)
        (make-directory mock-dir))
      (find-file mock-file)
      (goto-char (point-min))
      (if (looking-at "package mocks\n")
          (progn
            (goto-char (point-max))
            (insert "\n"))
        (insert "package mocks\n\n"))
      (insert "//go:generate mockgen -package mocks -source ../" current-file
              " -destination " (downcase mock-interface) ".go " mock-interface)))

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
        (newline-and-indent))))

  (with-eval-after-load 'lsp-mode
    (defvar my:lsp-go-directory-filters '())
    (lsp-register-custom-settings
     '(("gopls.directoryFilters" my:lsp-go-directory-filters)))))

(use-package go-dlv)

(use-package gotest
  :bind (:map go-mode-map
              ("C-c \\" . quit-compilation)
              :map go-test-mode-map
              ("C-c \\" . quit-compilation))
  :config
  (defun quit-compilation ()
    (interactive)
    (let ((buffer (compilation-find-buffer)))
      (if (get-buffer-process buffer)
	  (quit-process (get-buffer-process buffer))
        (error "The %s process is not running" (downcase mode-name))))
    ))

(use-package flycheck-golangci-lint
  :init
  (defun -flycheck-golangci-lint-setup ()
    (flycheck-golangci-lint-setup)
    (flycheck-add-next-checker 'lsp 'golangci-lint)))

;;Relies on `impl` and `godoc`
;;
;; go get -u github.com/josharian/impl
;; go get -u golang.org/x/tools/cmd/godoc
(use-package go-impl)
