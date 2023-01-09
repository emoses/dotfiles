

;; ;;Load auctex
(use-package tex
  :straight auctex
  :config
  (setq LaTeX-electric-left-right-brace t))
;; (add-hook 'text-mode-hook
;; 	  '(lambda () (auto-fill-mode 1)))

(use-package google-c-style
  :straight  (:type git :host github :repo "google/styleguide" :branch "gh-pages"))

(use-package cperl-mode
  :mode "\\.p[lm]\\'")

(use-package make-mode
  :mode (("^Makefile\\." . makefile-bsdmake-mode)))

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


(use-package flymd)

(use-package markdown-mode
  :after flymd
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
(unless (eq system-type 'windows-nt)
  (use-package haskell-mode
    :mode "\\.hs$"
    :config
    (autoload 'ghc-init "ghc" nil t)
    (autoload 'ghc-debug "ghc" nil t)
    (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
    (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
    (add-hook 'haskell-mode-hook 'ghc-init)))

;;Haml
(use-package haml-mode
  :config
  (add-hook 'haml-mode-hook (lambda ()
                              (local-unset-key (kbd "DEL")))))

;;Magit
(use-package magit
  :after (ivy evil)
  :bind (("C-x M-g" . magit-file-dispatch)
         ("C-x M-S-g" . magit-dispatch-popup)
         :map magit-blame-mode-map
         ("C-c RET" . magit-show-commit)
         ("C-c c" . magit-blame-cycle-style))
  :custom-face
  (magit-diff-file-heading ((t (:background "selectedTextBackgroundColor" :foreground "selectedTextColor"))))
  (magit-diff-file-heading-highlight ((t (:background "selectedContentBackgroundColor" :foreground "selectedTextColor" :weight bold))))
  :config
  (when (and my:osx (not with-editor-emacsclient-executable))
    (setq with-editor-emacsclient-executable (expand-file-name "~/bin/emacsclient")))
  (setq magit-branch-read-upstream-first nil)
  (advice-add 'magit-push-popup :around #'magit-push-arguments-maybe-upstream)
  (setq magit-completing-read-function #'ivy-completing-read)
  (setq magit-bury-buffer-function #'magit-mode-quit-window)
  (setq magit-process-finish-apply-ansi-colors t)

  (defun my:magit-rebase-onto-origin-master (args)
    (interactive (list (magit-rebase-arguments)))
    (if-let ((remote (magit-get-some-remote)))
        (magit-git-rebase (concat remote "/master") args)
      (user-error "Remote `%s' doesn't exist" args)))

  (transient-insert-suffix 'magit-rebase #'magit-rebase-branch
    '("o"
      (lambda ()
        (--when-let (magit-get-some-remote) (concat it "/master\n")))
      my:magit-rebase-onto-origin-master))

  (evil-ex-define-cmd "bl[ame]" #'magit-blame-addition)
  (evil-ex-define-cmd "history" #'magit-log-buffer-file))

(use-package magit-delta)

(use-package forge
  :after magit
  :init
  (defun my:forge-browse-after-create-pr (value headers status req)
    (if-let ((url (assoc 'html_url value)))
        (browse-url (cdr url))))
  (add-hook 'forge-post-submit-callback-hook #'my:forge-browse-after-create-pr))


(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode))

;; (use-package company-flx
;;   :ensure t
;;   :after company
;;   :config
;;   (company-flx-mode +1))

(use-package eldoc-overlay)

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
                      (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                      (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))

  (defun my:ediff-jump-to-control-frame-or-window ()
    (interactive)
    (unless (or (boundp 'ediff-control-buffer) ediff-control-buffer (ediff-in-control-buffer-p))
      (select-window (get-buffer-window ediff-control-buffer t))))

  (add-hook 'ediff-keymap-setup-hook (lambda ()
                                       (define-key ediff-mode-map "Q" #'my:quit-ediff-kill-buffers)
                                       (define-key ediff-mode-map "d" #'my:ediff-copy-both-to-C)
                                       (define-key ediff-mode-map "~" #'my:ediff-jump-to-control-frame-or-window))))


(use-package lua-mode
  :mode "\\.lua$" )

(use-package arduino-mode
  :mode (("\\.ino$" . cc-mode)
         ("\\.pde$" . cc-mode)))

(use-package win-switch
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

  (win-switch-setup-keys-hjkl (kbd "C-x o") (kbd "C-x C-o") (kbd "A-o"))
  (setq win-switch-idle-time 2)
  (setq win-switch-window-threshold 0)

  (defun my:win-switch-on-feedback ()
    (win-switch-on-alert)
    (setq win-switch-saved-mode-line-faces (face-attribute 'mode-line :box))
    (let ((box (plist-put (copy-sequence win-switch-saved-mode-line-faces) :color "red")))
      (unless (eq box (face-attribute 'mode-line :box))
        (set-face-attribute 'mode-line (selected-frame) :box box))))

  (defun my:win-switch-off-feedback ()
    (win-switch-off-alert)
    (unless (eq win-switch-saved-mode-line-faces (face-attribute 'mode-line :box))
      (set-face-attribute 'mode-line (selected-frame) :box win-switch-saved-mode-line-faces))
    (setq win-switch-saved-mode-line-faces nil))
  (setq win-switch-on-feedback-function #'my:win-switch-on-feedback)
  (setq win-switch-off-feedback-function #'my:win-switch-off-feedback))


(use-package elm-mode
  :mode "\\.elm$")

(use-package graphql-mode
  :mode "\\.graphqls$")

(use-package groovy-mode
  :mode "\\.groovy$")

(use-package plantuml-mode
  :mode "\\.plantuml$"
  :after (org)
  :config
  (setq plantuml-jar-path "~/lib/plantuml.jar")
  (setq plantuml-default-exec-mode 'jar)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t)))
  (setq org-plantuml-jar-path (expand-file-name "~/lib/plantuml.jar")))

(defun my:line-numbers-off ()
  (if (< emacs-major-version 26)
      (nlinum-mode -1)
    (display-line-numbers-mode -1)))

(use-package eshell
  :bind (("C-c M-B" . eshell-insert-buffer-filename))
  :config
  (defun eshell-insert-buffer-filename (buffer-name)
    (interactive "bName of buffer:")
    (insert-and-inherit "\"" (buffer-file-name (get-buffer buffer-name)) "\""))

  (defalias 'eshell/ff 'find-file)
  (defalias 'eshell/ffo 'find-file-other-from-eshell)
  (add-to-list 'eshell-modules-list 'eshell-tramp)

  (add-hook 'eshell-mode-hook #'my:line-numbers-off))

(use-package compile
  :config
  (add-hook 'compilation-mode-hook #'my:line-numbers-off))

(use-package xterm-color
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
  :mode "Dockerfile")

(use-package yaml-mode
  :mode "\\.ya?ml$")

(use-package  flycheck-yamllint
  :after (yaml-mode flycheck)
  :hook (flycheck-mode . flycheck-yamllint-setup))

(use-package scad-mode
  :mode "\\.scad$")

(use-package groovy-mode
  :mode "\\.groovy\\'")

(use-package jq-mode)

(use-package restclient
  :config
  ;(require 'restclient-jq)
  (defun restclient-start ()
    (interactive)
    (pop-to-buffer "*restclient*")
    (restclient-mode)))

(use-package cram-test-mode
  :mode "\\.t$"
  :straight  (:type git :host github :repo "macmodrov/cram-test-mode"))

(use-package protobuf-mode
  :mode "\\.proto$"
  :bind (:map protobuf-mode-map
              ("C-c C-c" . compile)))

(use-package treemacs
  :config
  (add-hook 'treemacs-mode-hook #'my:line-numbers-off))

(use-package powershell
  :mode "\\.ps1")

(unless (eq system-type 'windows-nt)
  (use-package vterm
    :hook (vterm-mode . my:line-numbers-off)))

(use-package terraform-mode
  :hook (terraform-mode . terraform-format-on-save-mode))

(use-package elixir-mode)

(use-package kubernetes-evil)

(use-package rego-mode
  :mode "\\.rego"
  :custom
  (rego-repl-executable "/usr/local/bin/opa")
  (rego-opa-command "/usr/local/bin/opa"))

(use-package nix-mode)

(use-package atomic-chrome
  :config
  (setq atomic-chrome-url-major-mode-alist
        '(("github\\.com" . gfm-mode)))
  (atomic-chrome-start-server))
