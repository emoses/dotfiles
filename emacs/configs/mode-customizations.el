
;; ;;Load auctex
;; (require 'tex-site)
;; (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; (add-hook 'text-mode-hook
;; 	  '(lambda () (auto-fill-mode 1)))

;; (load-library "p4")



;;Change default Perl mode to CPerl-mode
(setq auto-mode-alist
      (append '(
		("\\.p[lm]\\'" . cperl-mode)
	        ("\\.\\(cmp\\|app\\|evt\\)\\'" . nxml-mode)) ;;Lumen
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
(require 'cc-mode)
(define-key c-mode-base-map (kbd "C-c RET") 'compile)
(define-key c-mode-base-map (kbd "C-c s") 'c-set-style)

;;Matt Mode
(c-add-style "matt"
	     '("stroustrup"
                (c-offsets-alist
                 (innamespace . -)
                 (inline-open . 0)
                 (inher-cont . c-lineup-multi-inher)
                 (arglist-cont-nonempty . +)
                 (template-args-cont . +))
		(c-basic-offset . 2)))

;;;Turn on Syntax Hilighting
(add-hook 'c-mode-common-hook 'turn-on-font-lock)


;; For Python
;; (autoload 'python-mode "python-mode" "python major mode" t nil)
;; (setq auto-mode-alist
;;       (append '(
;; 		("\\.py$" . python-mode))
;; 		auto-mode-alist
;; 		))
;; (add-hook 'python-mode-hook
;; 	    ;; indent is 3 if it's a new file
;; 	    ;; (seems that the value is overridden when 
;; 	    ;; a source file is  loaded)
;; 	    (function (lambda () 
;; 	    		(set-variable 'py-indent-offset 3)))
;; 	    )
;; (add-hook 'python-mode-hook (function (lambda () (font-lock-mode))))

(require 'generic-x)
(when (locate-library "js2")
  (autoload 'js2-mode "js2" nil t)
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))


(autoload 'css-mode "css-mode" "Mode for editing CSS files" t)
(setq auto-mode-alist
      (append '(("\\.css$" . css-mode))
              auto-mode-alist))

(setq tramp-default-method "ssh")
