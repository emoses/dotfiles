
;;Start tree-sitter modes
;; (use-package treesit-auto
;;    :if (fboundp 'treesit-available-p)
;;    :config
;;    (delete 'yaml treesit-auto-langs)
;;    (global-treesit-auto-mode))

(add-to-list 'treesit-language-source-alist
             '(cedar . ("https://github.com/chrnorm/tree-sitter-cedar")))


;; TODO: this is temporary
(add-to-list 'treesit-language-source-alist
             '(cedarschema . ("~/dev/cedar-schema-treesitter")))

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


(use-package impatient-mode)

(use-package markdown-ts-mode
  ;; :mode ("\\.md\\'" . markdown-ts-mode)
  :if (<= emacs-major-version 30)
  :config
  (add-to-list 'treesit-language-source-alist '(markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown/src"))
  (add-to-list 'treesit-language-source-alist '(markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src")))

(use-package markdown-mode
  :mode (("\\.md$" . markdown-mode)
         ("\\.markdown$" . markdown-mode))
  :hook (markdown-mode . my:markdown-mode-hook)
  :bind (:map markdown-mode-map
              ("C-c C-c i" . imp-visit-buffer))
  :init
  (defun my:markdown-mode-hook ()
    (turn-on-auto-fill)
    (imp-set-user-filter #'markdown-filter))

  (defun markdown-filter (buffer)
    (princ
     (with-temp-buffer
       (let ((tmpname (buffer-name)))
         (set-buffer buffer)
         (set-buffer (markdown tmpname)) ; the function markdown is in `markdown-mode.el'
         (buffer-string)))
     (current-buffer)))
  :custom
  (markdown-command "pandoc --standalone --mathjax" "Use pandoc for markdown"))

(setq nxml-child-indent 4)

(use-package dired+
   :if (not my:osx)
   :load-path "~/.emacs.d/elisp"
   :config
   (setq diredp-hide-details-propagate-flag t))

;;Haskell
(use-package haskell-mode
   :if (not (eq system-type 'windows-nt))
   :mode "\\.hs$"
   :config
   (autoload 'ghc-init "ghc" nil t)
   (autoload 'ghc-debug "ghc" nil t)
   (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
   (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
   (add-hook 'haskell-mode-hook 'ghc-init))

;;Haml
(use-package haml-mode
  :config
  (add-hook 'haml-mode-hook (lambda ()
                              (local-unset-key (kbd "DEL")))))



(use-package eldoc-overlay)

(use-package ediff
  :config
  (setq ediff-split-window-function 'split-window-horizontally))

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

(use-package deflate)

(use-package plantuml-mode
  :mode "\\.plantuml$"
  :bind (:map plantuml-mode-map
              ("C-c C-e" . my:plantuml-preview-external))
  :after (org)
  :config
  (setq plantuml-jar-path "~/lib/plantuml.jar")
  (setq plantuml-default-exec-mode 'jar)
  (setq plantuml-svg-background "#FFFFFF")
  (add-to-list 'org-babel-load-languages '(plantuml . t))
  (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
  (setq org-plantuml-jar-path (expand-file-name "~/lib/plantuml.jar"))

  (defun my:plantuml-preview-external ()
    "Render current PlantUML diagram and open it in the OS default viewer."
    (interactive)
    (let* ((ext (or plantuml-output-type "svg"))
           (temp-file (make-temp-file "plantuml-" nil (concat "." ext))))
      ;; Generate image file via plantuml-mode
      (plantuml-execute-to-file (point-min) (point-max) temp-file ext)
      ;; Open using OS default handler
      (browse-url-of-file temp-file)))

  )

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

(use-package alert)
(use-package compile
  :bind (("C-c C-q" . kill-compilation)) ;; Also bound to C-c C-k, but why not both?
  :after alert
  :config
  (defun my:compile-finish-alert (buf str)
    ( if (string-match "finished" str)
        (alert "Compilation Succeeded"
               :title (format "Emacs Compile %s" (buffer-name buf))
               :severity 'low)
      (alert "Compilation failed"
             :title (format "Emacs Compile %s" (buffer-name buf))
             :severity 'high)))
  (add-hook 'compilation-mode-hook #'my:line-numbers-off)
  )

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
  :mode "\\.groovy$")

(use-package jq-mode)

(use-package restclient
  :mode ("\\.restclient$" . restclient-mode)
  :config
  (defun restclient-start ()
    (interactive)
    (pop-to-buffer "*restclient*")
    (restclient-mode)))

(use-package restclient-jq)

(use-package grpclient
  :mode ( "\\.grpclient$" . grpclient-mode)
  :straight (:type git :host github :repo "Prikaz98/grpclient.el"))

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

(use-package powershell-mode
  :mode "\\.ps1")

(unless (eq system-type 'windows-nt)
  (use-package vterm
    :hook (vterm-mode . my:line-numbers-off)))

(use-package terraform-mode
  :hook (terraform-mode . terraform-format-on-save-mode))

(use-package elixir-mode)

(use-package mix
  :after elixir-mode
  :hook (elixir-mode . mix-minor-mode))

(use-package kubernetes-evil)

(use-package rego-mode
  :mode "\\.rego"
  :custom
  (rego-repl-executable "/usr/local/bin/opa")
  (rego-opa-command "/usr/local/bin/opa"))

(use-package nix-mode)

(use-package sqlformat
  :after sql
  :bind (:map sql-mode-map
              ("C-c C-f" . 'sqlformat))
  :custom (sqlformat-command 'pgformatter))

(use-package rustic
  :mode ("\\.rs$" . rustic-mode)
  :config
  (setq rustic-format-on-save nil)
  :custom
  (rustic-cargo-use-last-stored-arguments nil)
  )

(use-package cue-mode
  :mode "\\.cue$")

(use-package bazel
  :mode ("Tiltfile" . bazel-starlark-mode))

(use-package gcode-mode
  :mode "\\.gcode")

(use-package comment-dwim-2
  :bind ("M-;" . comment-dwim-2))
