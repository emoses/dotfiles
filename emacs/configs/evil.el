(require 'evil)
(evil-mode 1)

;;Mode which start in emacs state
(add-to-list 'evil-emacs-state-modes 'dired-mode)
(add-to-list 'evil-emacs-state-modes 'git-rebase-mode)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq evil-symbol-word-search t)))
