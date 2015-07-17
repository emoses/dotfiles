
;; ;;Load auctex
;; (require 'tex-site)
;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; (add-hook 'text-mode-hook
;; 	  '(lambda () (auto-fill-mode 1)))

;; (load-library "p4")

(require 'google-c-style)



;;Change default Perl mode to CPerl-mode
(setq auto-mode-alist
      (append '(("\\.p[lm]\\'" . cperl-mode))
	      auto-mode-alist
	      ))


;;For PHP
(autoload 'php-mode "php-mode" "PHP major mode" t nil)
(add-hook 'php-mode-hook 'turn-on-font-lock)
(setq auto-mode-alist
      (append '(
		("\\.php$" . php-mode)
		("\\.phtml$" . php-mode))
	      auto-mode-alist
		))

;;; Some useful C-mode stuff
(add-hook 'c-mode-common-hook
      (lambda ()
            (define-key c-mode-base-map (kbd "C-c RET") 'compile)
            (define-key c-mode-base-map (kbd "C-c s") 'c-set-style)
            (google-set-c-style)
            (setq c-basic-offset 4)
            (turn-on-font-lock)))

(require 'generic-x)
(autoload 'js2-mode "js2-mode" "Fancy mode for editing JS" t)
(add-to-list 'auto-mode-alist '("\\.jsx?$" . js2-mode))
;;TODO: refine path and make project-specific settings
(defun my:js2-externs (filename)
  (let ((path-list (split-string (file-name-directory filename) "/"))
        (base-includes '("global")))
    (when (member "keymaker" path-list)
      (cond
       ((member "test" path-list) (append '("describe" "before" "beforeEach" "after" "afterEach" "it" "assert" "sinon" "include") base-includes))
       ((member "src" path-list) (append '("global") base-includes))
       ((member "lib" path-list) (append '("global" "include" "process")))))))

(add-hook 'js2-mode-hook
	  (function (lambda ()
		      (local-unset-key (kbd "C-c C-a"))
		      (set-variable 'indent-tabs-mode nil)
                      (set-variable 'js2-additional-externs (my:js2-externs (buffer-file-name))))))
(set-variable 'js2-global-externs '("require" "module"))
(set-variable 'flycheck-eslintrc "eslint.json")

(autoload 'css-mode "css-mode" "Mode for editing CSS files" t)
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))

(autoload 'markdown-mode "markdown-mode" "Major mode for Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))

(add-hook 'jade-mode-hook
	  (lambda ()
	    (set-variable 'tab-width 4)))

(setq nxml-child-indent 4)

(when (not my:osx)
  (require 'dired-details+))

;;Haskell
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'ghc-init)
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))

;;Haml
(add-hook 'haml-mode-hook (lambda ()
			    (local-unset-key (kbd "DEL"))))

;;Magit
(require 'magit-gh-pulls)
(add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)

(require 'auto-complete-config)
(ac-config-default)

;;Eclim
;(require 'ac-emacs-eclim-source)
;(ac-emacs-eclim-config)

;;At least three spaces in linum mode
;;Mostly copy/paste from linum.el

(setq linum-format (lambda (line)
                     (let* ((w (max 3
                                   (length (number-to-string
                                            (count-lines (point-min) (point-max))))))
                            (fmt (concat "%" (number-to-string w) "d")))
                       (propertize (format fmt line) 'face 'linum))))

(autoload 'web-mode "web-mode" "web editing mode" t)
(add-to-list 'auto-mode-alist '("\\.html?$" . web-mode))

(autoload 'lua-mode "lua-mode" "lua mode" t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))

(require 'win-switch)
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
(setq win-switch-idle-time 2)
(setq win-switch-window-threshold 0)
