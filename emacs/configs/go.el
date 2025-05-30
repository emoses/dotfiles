  (defun my:go-mode-hooks ()
    (ivy-mode t)
    (indent-tabs-mode t)
    (add-hook 'before-save-hook #'maybe-lsp-format-buffer t t)
    (add-hook 'before-save-hook #'maybe-lsp-organize-imports t t)
    ;;this can improperly remove trailing whitespace from multiline strings
    (remove-hook 'before-save-hook #'delete-trailing-whitespace t)
    (set (make-local-variable 'compile-command) "go build")
    (set (make-local-variable 'yas-indent-line) 'fixed)
    (set (make-local-variable 'compilation-skip-threshold) 2))

;; This is easier than trying to the env var set properly on macos
(setenv "ASDF_GOLANG_MOD_VERSION_ENABLED" "false")

(use-package go-ts-mode
   :if (treesit-available-p)
   :bind (:map go-ts-mode-map
               ("C-c C-a" . go-import-add)
	       ("C-c C-c" . compile)
	       ;; This overrides godef-describe
	       ("C-c C-d" . my:godoc-maybe-at-point)
	       ("C-c d" . godef-describe)
	       )
   :config
   (add-hook 'go-ts-mode-hook #'my:go-mode-hooks)
   )

(use-package go-mode
  :mode "\\.go$"
  :bind (:map go-mode-map
              ("C-c C-c" . compile)
              ;; This overrides godef-describe
              ("C-c C-d" . my:godoc-maybe-at-point)
              ("C-c d" . godef-describe))
  :config
  (defun my:go-local-var-hooks ()
    (when (or (derived-mode-p 'go-mode) (derived-mode-p 'go-ts-mode))
      (lsp)))

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
           (current-file (file-name-nondirectory (buffer-file-name)))q
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
     '(("gopls.directoryFilters" my:lsp-go-directory-filters)
       ("gopls.buildFlags" ["-tags=dev"])
       ("golangci-lint.command"
         ["golangci-lint" "run" "--modules-download-mode=vendor" "--enable-all" "--disable" "lll" "--out-format" "json" "--issues-exit-code=1"])))

     (lsp-register-client
      (make-lsp-client :new-connection (lsp-stdio-connection
                                        '("golangci-lint-langserver"))
                       :activation-fn (lsp-activate-on "go")
                       :language-id "go"
                       :priority 0
                       :server-id 'golangci-lint
                       :add-on? t
                       :library-folders-fn #'lsp-go--library-default-directories
                       :initialization-options (lambda ()
                                                 (gethash "golangci-lint"
                                                          (lsp-configuration-section "golangci-lint")))))))

(use-package go-dlv
  :config
  (defalias 'dlv-this-func #'dlv-current-func))

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
    )

  (with-eval-after-load 'go-ts-mode
    (define-key go-mode-map (kbd "C-c \\") #'quit-compilation)))

;;Relies on `impl` and `godoc`
;;
;; go get -u github.com/josharian/impl
;; go get -u golang.org/x/tools/cmd/godoc
(use-package go-impl
  :after exec-path-from-shell)

(when (treesit-available-p)
  (defun go-beginning-of-defun ()
    (treesit-beginning-of-defun)))

(defalias 'jsontag
   (kmacro "^ y i W A SPC j s o n <tab> <escape> p v i \" M-x s n a k e c a <return> "))
