(require 'evil)
(define-key evil-motion-state-map (kbd "TAB") nil)
(evil-mode 1)

;;Mode which start in emacs state
(add-to-list 'evil-emacs-state-modes 'dired-mode)
(add-to-list 'evil-emacs-state-modes 'cider-docview-mode)

;;Start in insert state for repl
(add-to-list 'evil-insert-state-modes 'cider-repl-mode)
(add-to-list 'evil-emacs-state-modes 'git-rebase-mode)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq evil-symbol-word-search t)))
