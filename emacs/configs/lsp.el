(use-package lsp-mode
  :bind (("C-c M-r" . lsp-rename)
         ("M-/" . lsp-find-definition)
         ("C-}" . lsp-find-implementation))
  :hook ((python-mode . lsp)
         (typescript-mode . lsp))
  :init
  (setq lsp-keymap-prefix "A-l")
  :commands (lsp lsp-deferred)
  :config

  ;; change nil to 't to enable logging of packets between emacs and the LS
  ;; this was invaluable for debugging communication with the MS Python Language Server
  ;; and comparing this with what vs.code is doing
  (setq lsp-log-io nil)
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
    (setq lsp-ui-peek-always-show t)
    (add-hook 'lsp-mode-hook 'lsp-ui-mode)
    (add-hook 'lsp-ui-imenu-mode-hook (lambda () (display-line-numbers-mode -1)))
    (defun lsp-ui-peek-find-type-definition (&optional extra)
      (interactive)
      (lsp-ui-peek-find-custom "textDocument/typeDefinition" extra)))

  ;; make sure we have lsp-imenu everywhere we have LSP
  ;;  (require 'lsp-imenu)
  ;; (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)

  (use-package lsp-treemacs
    :straight (:files (:defaults "icons")))

  (lsp-define-conditional-key lsp-command-map "To" lsp-treemacs-symbols (fboundp 'lsp-treemacs-symbols))
  (lsp-define-conditional-key lsp-command-map "Gt" lsp-ui-peek-find-type-definition (and (lsp-feature? "textDocument/typeDefinition")
                                                                                         (fboundp 'lsp-ui-peek-find-custom))))
