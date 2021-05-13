(use-package jest)
(defun -jest-add-bindings (mode-map)
  (bind-key (kbd "C-c t") #'jest-popup mode-map)
  (bind-key (kbd "C-c T") #'jest-repeat mode-map))

(use-package add-node-modules-path)

(use-package js2-mode
  :mode "\\.js$"
  :after (add-node-modules-path)
  :config
  (add-hook 'js2-mode-hook
            (function (lambda ()
                        (local-unset-key (kbd "C-c C-a"))
                        (js2-mode-hide-warnings-and-errors)
                        (set-variable 'indent-tabs-mode nil)
                        (add-node-modules-path))))
  (setq js2-global-externs '("require" "module"))
  (setq js-indent-level 2)
  (-jest-add-bindings js2-mode-map))


(use-package rjsx-mode
  :mode "\\.jsx$"
  :config
  (flycheck-add-mode 'javascript-eslint 'rjsx-mode))

(use-package xref-js2
  :after js2-mode
  :custom
  (xref-js2-ignored-dirs '("node-modules" "build" "dist" "fontawesome"))
  :config
  (add-hook 'js2-mode-hook (lambda ()
                             (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t))))

(use-package web-mode
  :mode (("\\.html?$" . web-mode)
         ("\\.tsx$" . web-mode))
  :config
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (setq web-mode-enable-auto-quoting nil)
  (setq web-mode-content-types-alist
        '(("jsx" . "\\.tsx$")))
  (defun web-mode-tsx-hook ()
    (let* ((name (buffer-file-name))
           (name (or name (buffer-name))))
      (when (string-match-p "\\.tsx$" name)
        (lsp))))
  (add-hook 'web-mode-hook #'web-mode-tsx-hook)
  (-jest-add-bindings web-mode-map))

(use-package typescript-mode
  :after (lsp lsp-ui flycheck)
  :mode "\\.ts$"
  :config
  ;TODO: merge this with web-mode setup?
  (flycheck-add-mode 'javascript-eslint 'typescript-mode)
  (flycheck-add-next-checker 'lsp '(t . javascript-eslint))
  (-jest-add-bindings typescript-mode-map))

(use-package json-mode
  :mode "\\.json$"
  :config
  (add-hook 'json-mode-hook
            (lambda ()
              (make-local-variable 'js-indent-level)
              (setq js-indent-level 2))))


(use-package css-mode
  :mode "\\.css$")

(use-package less-css-mode
  :mode "\\.less$")

;; Copied from https://github.com/Fuco1/compile-eslint/
;; Which has problems with loading 'compile before evaluating 'form below
(require 'compile)

(defun compile-eslint--find-filename ()
  "Find the filename for current error."
  (save-match-data
    (save-excursion
      (when (re-search-backward (rx bol (group "/" (+ any)) eol) nil t)
        (list (match-string 1))))))

(let ((form `(eslint
              ,(rx-to-string
                '(and (group (group (+ digit)) ":" (group (+ digit)))
                      (+ " ") (or "error" "warning")))
              compile-eslint--find-filename
              2 3 2 1)))
  (if (assq 'eslint compilation-error-regexp-alist-alist)
      (setf (cdr (assq 'eslint compilation-error-regexp-alist-alist)) (cdr form))
    (push form compilation-error-regexp-alist-alist)))
;; End copy
(push 'eslint compilation-error-regexp-alist)
