
(use-package evil
  :ensure t
  :bind (:map evil-motion-state-map
              ("[tab]" . nil))
  :init
  (setq evil-want-integration nil)
  :config
  (global-evil-leader-mode 1)
  (evil-mode 1)
  (setq evil-default-cursor t)

  (define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)
  (define-key evil-normal-state-map (kbd "S-SPC") 'ace-jump-char-mode)

  ;;Mode which start in emacs state
  (add-to-list 'evil-emacs-state-modes 'dired-mode)
  (add-to-list 'evil-emacs-state-modes 'cider-docview-mode)
  (add-to-list 'evil-emacs-state-modes 'git-rebase-mode)

  ;;Start in insert state for repl
  (add-to-list 'evil-insert-state-modes 'cider-repl-mode)
  (add-to-list 'evil-insert-state-modes 'inf-clojure-mode)

  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (setq evil-symbol-word-search t)))
  ;;Make snake_case part of words for python
  (add-hook 'python-mode-hook (lambda () (modify-syntax-entry ?_ "w"))))

(use-package evil-org
  ;:load-path "~/.emacs.d/plugins/evil-org-mode"
  :after evil
  :ensure t
  :config
  ;;Unbind J and K from evil org.
  (evil-define-key 'normal evil-org-mode-map
    "J" nil
    "K" nil))

(use-package evil-leader
  :after evil
  :ensure t)

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (setq evil-collection-mode-list
        '(ace-jump-mode
          ag
                                        ;calc
          cider
          diff-mode
          eldoc
          elisp-mode
          eshell
          flycheck
          info
                                        ;ivy
          js2-mode
          lua-mode
          magit
          occur
          (package-menu package)
          paren
          python
          ruby-mode
          (term term ansi-term multi-term)
          which-key
          ))
  (evil-collection-init))
