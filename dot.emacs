;;; Evan Moses .emacs
;;; Feel free to copy

;; default xemacs configuration directory
(defconst my:emacs-config-dir "~/dotfiles/emacs/configs/" "")

;; utility finction to auto-load my package configurations
(defun my:load-config-file (filelist)
  (dolist (file filelist)
    (load (expand-file-name 
	   (concat my:emacs-config-dir file)))
    (message "Loaded config file:%s" file)
    ))

(my:load-config-file '("package.el"
		       "org-mode-init.el"
		       "keys.el"
		       "faces.el"
		       ;;"select-cvs.el"
		       "mode-customizations.el"
		       ;;"work.el"
		       "misc-fns.el"
		       "clojure.el"))

(setq load-path (cons "~/emacs/" load-path))
(setq inhibit-splash-screen t)

(put 'scroll-left 'disabled nil)


;;Org-mode local customizations:
(setq org-mobile-directory "~/Dropbox/MobileOrg")
(setq org-directory "~/Dropbox/org")

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(js2-bounce-indent-flag nil)
 '(js2-strict-inconsistent-return-warning nil)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 1) ((control)))))
 '(org-agenda-files (quote ("~/Dropbox/org/work.org" "~/Dropbox/org/home.org")))
 '(org-log-done (quote time))
 '(org-mobile-inbox-for-pull (concat org-directory "/from-mobile.org"))
 '(org-modules (quote (org-bbdb org-bibtex org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-mouse)))
 '(org-refile-targets (quote ((org-agenda-files :maxlevel . 3)))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(js2-error-face ((((class color) (background dark)) (:foreground "pale turquoise" :weight bold)))))


