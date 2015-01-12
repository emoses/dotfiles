
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
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook
	  (function (lambda ()
		      (local-unset-key (kbd "C-c C-a"))
		      (set-variable 'indent-tabs-mode nil))))

(autoload 'css-mode "css-mode" "Mode for editing CSS files" t)
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))

(autoload 'markdown-mode "markdown-mode" "Major mode for Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))

(add-hook 'jade-mode-hook
	  (lambda ()
	    (set-variable 'tab-width 4)))
	 
(setq nxml-child-indent 4)

(require 'dired-details+)

;;Haskell
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'ghc-init)
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))


;;Magit
(require 'magit-gh-pulls)
(add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)

;;Eclim
(require 'auto-complete-config)
(ac-config-default)
(require 'ac-emacs-eclim-source)
(ac-emacs-eclim-config)
