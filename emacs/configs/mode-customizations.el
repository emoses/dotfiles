
;; ;;Load auctex
;; (require 'tex-site)
;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; (add-hook 'text-mode-hook
;; 	  '(lambda () (auto-fill-mode 1)))

;; (load-library "p4")

(use-package google-c-style
  :ensure t)

(use-package cperl-mode
  :ensure t
  :mode "\\.p[lm]\\'")

;;For PHP
(use-package php-mode
  :mode (("\\.php$" . php-mode)
         ("\\.phtml$" . php-mode))
  :config
  (add-hook 'php-mode-hook 'turn-on-font-lock))

;;; Some useful C-mode stuff
(add-hook 'c-mode-common-hook
      (lambda ()
            (define-key c-mode-base-map (kbd "C-c RET") 'compile)
            (define-key c-mode-base-map (kbd "C-c s") 'c-set-style)
            (google-set-c-style)
            (setq c-basic-offset 4)
            (turn-on-font-lock)))

(require 'generic-x)

(use-package js2-mode
  :mode "\\.jsx?$"
  :config
  (defun my:js2-externs (filename)
    (if (not filename)
        nil
      (let ((path-list (split-string (file-name-directory filename) "/"))
            (base-includes '("global")))
        (when (member "keymaker" path-list)
          (cond
           ((member "test" path-list) (append '("describe" "before" "beforeEach" "after" "afterEach" "it" "assert" "sinon" "include") base-includes))
           ((member "src" path-list) (append '("global") base-includes))
           ((member "lib" path-list) (append '("global" "include" "process"))))))))

  (add-hook 'js2-mode-hook
            (function (lambda ()
                        (local-unset-key (kbd "C-c C-a"))
                        (js2-mode-hide-warnings-and-errors)
                        (set-variable 'indent-tabs-mode nil)
                        (set-variable 'js2-additional-externs (my:js2-externs (buffer-file-name))))))
  (set-variable 'js2-global-externs '("require" "module"))
  )

(use-package css-mode
  :ensure t
  :mode "\\.css$")

(use-package less-css-mode
  :ensure t
  :mode "\\.less$")

(use-package markdown-mode
  :ensure t
  :mode (("\\.md$" . markdown-mode)
         ("\\.markdown$" . markdown-mode)))

(use-package jade-mode
  :ensure t
  :config
  (add-hook 'jade-mode-hook
            (lambda ()
              (set-variable 'tab-width 4))))

(setq nxml-child-indent 4)

(when (not my:osx)
  (use-package dired-details+
    :ensure t))

;;Haskell
(use-package haskell-mode
  :ensure t
  :mode "\\.hs$"
  :config
  (autoload 'ghc-init "ghc" nil t)
  (autoload 'ghc-debug "ghc" nil t)
  (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook 'ghc-init))

;;Haml
(use-package haml-mode
  :ensure t
  :config
  (add-hook 'haml-mode-hook (lambda ()
                              (local-unset-key (kbd "DEL")))))

;;Magit
(use-package magit
  :ensure t
  :config
  (setq magit-branch-read-upstream-first nil)
  (advice-add 'magit-push-popup :around #'magit-push-arguments-maybe-upstream)
  (setq magit-completing-read-function #'magit-ido-completing-read))

(use-package magit-gh-pulls
  :ensure t
  :config
  (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))

(use-package auto-complete
  :ensure t
  :config
  (require 'auto-complete-config)
  (ac-config-default))

;;Eclim
;(require 'ac-emacs-eclim-source)
;(ac-emacs-eclim-config)

(use-package ediff
  :defer t
  :config
  (defun my:quit-ediff-kill-buffers ()
    (interactive)
    (ediff-barf-if-not-control-buffer)
    (let ((ed-frame (window-frame ediff-window-A)))
      (ediff-quit t)
      (kill-buffer ediff-buffer-A)
      (kill-buffer ediff-buffer-B)
      (kill-buffer ediff-buffer-C)
      (when ed-frame
        (delete-frame ed-frame))))
  (add-hook 'ediff-keymap-setup-hook (lambda ()
                               (define-key ediff-mode-map "Q" #'my:quit-ediff-kill-buffers))))

(use-package web-mode
  :ensure t
  :mode "\\.html?$")

(use-package lua-mode
  :ensure t
  :mode "\\.lua$" )

(use-package arduino-mode
  :ensure t
  :mode (("\\.ino$" . cc-mode)
         ("\\.pde$" . cc-mode)))

(use-package win-switch
  :ensure t
  :config
  (defun win-switch-setup-keys-hjkl (&rest dispatch-keys)
    (interactive)
    (win-switch-set-keys '("j") 'down)
    (win-switch-set-keys '("k") 'up)
    (win-switch-set-keys '("h") 'left)
    (win-switch-set-keys '("l") 'right)
    (win-switch-set-keys '("J") 'shrink-vertically)
    (win-switch-set-keys '("K") 'enlarge-vertically)
    (win-switch-set-keys '("H") 'shrink-horizontally)
    (win-switch-set-keys '("L") 'enlarge-horizontally)
    (win-switch-set-keys '(" ") 'other-frame)
    (win-switch-set-keys '("r" [return] [escape]) 'exit)
    (win-switch-set-keys '("3") 'split-horizontally)
    (win-switch-set-keys '("2") 'split-vertically)
    (win-switch-set-keys '("0") 'delete-window)
    (win-switch-set-keys '("\M-\C-g") 'emergency-exit)
    (dolist (key dispatch-keys)
      (global-set-key key 'win-switch-dispatch)))

  (win-switch-setup-keys-hjkl (kbd "C-x o") (kbd "C-x C-o"))
  (setq win-switch-idle-time 2)
  (setq win-switch-window-threshold 0))

(use-package typescript-mode
  :ensure t
  :mode "\\.ts$")

(use-package json-mode
  :mode "\\.json$"
  :config
  (add-hook 'json-mode-hook
            (lambda ()
              (make-local-variable 'js-indent-level)
              (setq js-indent-level 2))))

(use-package elm-mode
  :ensure t
  :mode "\\.elm$")
