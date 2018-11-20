
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
  (define-key evil-insert-state-map (kbd "C-+") 'company-complete)

  (cl-loop for (mode . state) in '( ;; Start in emacs mode
                                (dired-mode . emacs)
                                (cider-docview-mode . emacs)
                                (git-rebase-mode . emacs)
                                 ;; Start in insert mode
                                (cider-repl-mode . insert)
                                (inf-clojure-mode . insert)
                                (git-commit-mode . insert))
        do (evil-set-initial-state mode state))

  (defun my:evil-write (&rest args)
    "I constantly hit :w2<ret> and save a file named 2.  Verify that I want to do that"
    (if (equal "2" (nth 3 args))
        (y-or-n-p "Did you really mean to save a file named 2?")
      t))
  (advice-add #'evil-write :before-while #'my:evil-write)

  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (setq evil-symbol-word-search t)))
  ;;Make snake_case part of words for python
  (add-hook 'python-mode-hook (lambda () (modify-syntax-entry ?_ "w"))))

(use-package evil-leader
  :after evil
  :ensure t)

(use-package evil-org
  ;:load-path "~/.emacs.d/plugins/evil-org-mode"
  :after evil
  :ensure t
  :config
  ;;Unbind J and K from evil org.
  (evil-define-key 'normal evil-org-mode-map
    "J" nil
    "K" nil))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (setq evil-collection-mode-list
        '(ace-jump-mode
          ag
                                        ;calc
          cider
          company
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
          neotree
          (occur replace)
          (package-menu package)
          paren
          python
          ruby-mode
          (term term ansi-term multi-term)
          which-key
          ))

  (defun my:customize-evil-collection-occur (mode keymaps &rest _rest)
    (when (equal mode 'occur)
      (evil-define-key 'normal occur-mode-map
        "q" #'quit-window)))

  (add-hook 'evil-collection-setup-hook #'my:customize-evil-collection-occur)
  (evil-collection-init))

(use-package evil-cleverparens
  :ensure t
  :after evil)
