(setq lsp-keymap-prefix "A-l")

(use-package ccls
  :custom
  (ccls-executable "/usr/local/bin/ccls"))

(use-package lsp-mode
  :bind (("C-c M-r" . lsp-rename)
         ("M-/" . lsp-find-definition)
         ("C-}" . lsp-find-implementation))
  :hook ((python-mode . lsp)
         (typescript-mode . lsp)
         (rjsx-mode . lsp)
         (elixir-mode . lsp)
         (c-mode . lsp))
  ;;:straight (:files (:defaults "clients/*.el"))
  :commands (lsp lsp-deferred)
  :init
  (add-to-list 'exec-path "D:/elixir-ls-1.11")
  :config

  (setq lsp-nested-project-separator nil)
  (defun my:lsp--filter-variables (filter-fn sym)
    (if (= 13 (gethash "kind" sym))
        (progn
          (message "found var")
          nil)
      (funcall filter-fn sym)))
  (advice-add 'lsp--symbol-filter :around #'my:lsp--filter-variables)

  ;;Requires modified lsp-mode
  (setq lsp-show-message-request-filter (lambda (message actions)
                                          (if (string-match-p "^Inconsistent vendoring detected" message)
                                              nil
                                            actions)))

  (lsp-define-conditional-key lsp-command-map "To" lsp-treemacs-symbols "Treemacs symbols" (fboundp 'lsp-treemacs-symbols))
  (lsp-define-conditional-key lsp-command-map "Gt" lsp-ui-peek-find-type-definition "Go to type definition" (and (lsp-feature? "textDocument/typeDefinition")
                                                                                                                 (fboundp 'lsp-ui-peek-find-custom)))
  (lsp-define-conditional-key lsp-command-map "sr" lsp-workspace-restart "Restart server" (lsp-workspaces))
  (lsp-define-conditional-key lsp-command-map "ss" lsp "Start server" t))

  ;; lsp-ui gives us the blue documentation boxes and the sidebar info
(use-package lsp-ui
    :bind (:map lsp-ui-mode-map
           ("S-<f4>" . lsp-ui-imenu))
    :commands lsp-ui-mode
    :config
    (setq lsp-ui-sideline-ignore-duplicate t)
    (setq lsp-ui-sideline-enable nil)
    (setq lsp-ui-peek-always-show t)
    (add-hook 'lsp-mode-hook 'lsp-ui-mode)
    (add-hook 'lsp-ui-imenu-mode-hook (lambda () (display-line-numbers-mode -1)))
    (defun lsp-ui-peek-find-type-definition (&optional extra)
      (interactive)
      (lsp-ui-peek-find-custom "textDocument/typeDefinition" extra)))

(use-package  lsp-ivy
  :straight (lsp-ivy :type git :host github :repo "emacs-lsp/lsp-ivy")
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list
  :straight (:files (:defaults "icons")))
