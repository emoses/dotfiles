(use-package evil-leader
  :ensure t)

(use-package evil-org
  :load-path "~/.emacs.d/plugins/evil-org-mode")

(use-package evil
  :ensure t
  :bind (:map evil-motion-state-map
              ("[tab]" . nil))
  :config
  (global-evil-leader-mode 1)
  (evil-mode 1)
  (setq evil-default-cursor t)

  ;;Mode which start in emacs state
  (add-to-list 'evil-emacs-state-modes 'dired-mode)
  (add-to-list 'evil-emacs-state-modes 'cider-docview-mode)
  (add-to-list 'evil-emacs-state-modes 'git-rebase-mode)

  ;;Start in insert state for repl
  (add-to-list 'evil-insert-state-modes 'cider-repl-mode)
  (add-to-list 'evil-insert-state-modes 'inf-clojure-mode)

  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (setq evil-symbol-word-search t))))
