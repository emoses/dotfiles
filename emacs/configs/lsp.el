(use-package lsp-mode
  :bind (("C-c M-r" . lsp-rename)
         ("M-/" . lsp-find-definition))
  :hook ((python-mode . lsp)
         (typescript-mode . lsp))
  :commands (lsp lsp-deferred)
  :config

  ;; change nil to 't to enable logging of packets between emacs and the LS
  ;; this was invaluable for debugging communication with the MS Python Language Server
  ;; and comparing this with what vs.code is doing
  (setq lsp-print-io nil)
  (setq lsp-prefer-flymake nil)
  (setq lsp-enable-snippet nil)
  (defun my:lsp--filter-variables (filter-fn sym)
    (if (= 13 (gethash "kind" sym))
        (progn
          (message "found var")
          nil)
      (funcall filter-fn sym)))
  (advice-add 'lsp--symbol-filter :around #'my:lsp--filter-variables)

  ;; lsp-ui gives us the blue documentation boxes and the sidebar info
  (use-package lsp-ui
    :bind (:map lsp-ui-mode-map
           ("S-<f4>" . lsp-ui-imenu))
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
    :custom
    (company-lsp-enable-snippet nil)
    :config
    (push 'company-lsp company-backends)))
