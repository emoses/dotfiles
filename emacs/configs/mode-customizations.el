

;; ;;Load auctex
;; (require 'tex-site)
;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; (add-hook 'text-mode-hook
;; 	  '(lambda () (auto-fill-mode 1)))

(use-package google-c-style
  :ensure t)

(use-package cperl-mode
  :ensure t
  :mode "\\.p[lm]\\'")

;;For PHP
(use-package php-mode
  :ensure t
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

(use-package add-node-modules-path
  :ensure t)

(use-package js2-mode
  :ensure t
  :after (add-node-modules-path)
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
                        (set-variable 'js2-additional-externs (my:js2-externs (buffer-file-name)))
                        (add-node-modules-path))))
  (setq js2-global-externs '("require" "module"))
  (setq js-indent-level 2)
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
         ("\\.markdown$" . markdown-mode))
  :init (setq markdown-command "pandoc"))

(setq nxml-child-indent 4)

(when (not my:osx)
  (use-package dired+
    :load-path "~/.emacs.d/elisp"
    :config
    (setq diredp-hide-details-propagate-flag t)))

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
  (when (and my:osx (not with-editor-emacsclient-executable))
    (setq with-editor-emacsclient-executable (expand-file-name "~/bin/emacsclient")))
  (setq magit-branch-read-upstream-first nil)
  (advice-add 'magit-push-popup :around #'magit-push-arguments-maybe-upstream)
  (setq magit-completing-read-function #'magit-ido-completing-read)
  (setq magit-bury-buffer-function #'magit-mode-quit-window)
  (global-magit-file-mode t))

(use-package magit-gh-pulls
  :ensure t
  :config
  (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode))

(use-package company-flx
  :ensure t
  :after company
  :config
  (company-flx-mode +1))

(use-package eldoc-overlay
  :ensure t)

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

  (defun my:ediff-copy-both-to-C ()
    "Copy both regions to C during diff3

   Via https://stackoverflow.com/a/29757750"
    (interactive)
    (ediff-copy-diff ediff-current-difference nil 'C nil
                     (concat
                      (ediff-get-region-contents ediff-currrent-difference 'A ediff-control-buffer)
                      (ediff-get-region-contents ediff-currrent-difference 'B ediff-control-buffer))))

  (defun my:ediff-jump-to-control-frame-or-window ()
    (interactive)
    (unless (or (boundp 'ediff-control-buffer) ediff-control-buffer (ediff-in-control-buffer-p))
      (select-window (get-buffer-window ediff-control-buffer t))))

  (add-hook 'ediff-keymap-setup-hook (lambda ()
                                       (define-key ediff-mode-map "Q" #'my:quit-ediff-kill-buffers)
                                       (define-key ediff-mode-map "d" #'my:ediff-copy-both-to-C)
                                       (define-key ediff-mode-map "~" #'my:ediff-jump-to-control-frame-or-window))))

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
    (win-switch-set-keys '("`") 'other-frame)
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
  :ensure t
  :mode "\\.json$"
  :config
  (add-hook 'json-mode-hook
            (lambda ()
              (make-local-variable 'js-indent-level)
              (setq js-indent-level 2))))

(use-package elm-mode
  :ensure t
  :mode "\\.elm$")

(use-package graphql-mode
  :ensure t
  :mode "\\.graphqls$")

(use-package groovy-mode
  :ensure t
  :mode "\\.groovy$")

(use-package plantuml-mode
  :ensure t
  :defer t
  :mode "\\.plantuml$"
  :config
  (setq plantuml-jar-path "~/lib/plantuml.jar"))

(use-package eshell
  :bind (("C-c M-B" . eshell-insert-buffer-filename))
  :config
  (defun eshell-insert-buffer-filename (buffer-name)
    (interactive "bName of buffer:")
    (insert-and-inherit "\"" (buffer-file-name (get-buffer buffer-name)) "\""))

  (add-hook 'eshell-mode-hook (lambda () (if (< 26 emacs-major-version)
                                             (nlinum-mode -1)
                                           (display-line-numbers-mode -1)))))

(use-package xterm-color
  :ensure t
  :after (magit eshell)
  :config
  (add-hook 'eshell-before-prompt-hook
            (lambda () (setq xterm-color-preserve-properties t)))
  (when (fboundp 'eshell-preoutput-filter-functions)
    (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter))

  (when (fboundp 'eshell-output-filter-functions)
    (setq eshell-output-filter-functions (remove 'eshell-handle-ansi-color eshell-output-filter-functions)))
  (add-hook 'eshell-mode-hook (lambda () (setenv "TERM" "xterm-256color")))

  (defun my:xterm-color-magit (args)
    (list (car args) (xterm-color-filter (second args))))
  (advice-add 'magit-process-filter :filter-args #'my:xterm-color-magit))

(use-package dockerfile-mode
  :ensure t
  :mode "Dockerfile")

(use-package yaml-mode
  :ensure t
  :mode "\\.ya?ml$")

(use-package scad-mode
  :ensure t
  :mode "\\.scad$")
