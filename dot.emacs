;;; -*- mode: emacs-lisp -*-
;;; Evan Moses .emacs
;;; Feel free to copy
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" default)))
 '(js2-bounce-indent-flag nil)
 '(js2-strict-inconsistent-return-warning nil)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 1) ((control)))))
 '(org-agenda-files (quote ("~/Dropbox/org/work.org" "~/Dropbox/org/home.org")))
 '(org-log-done (quote time))
 '(org-mobile-inbox-for-pull (concat org-directory "/from-mobile.org"))
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-mouse)))
 '(org-refile-targets (quote ((org-agenda-files :maxlevel . 3)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-error-face ((((class color) (background dark)) (:foreground "pale turquoise" :weight bold)))))

;; default xemacs configuration directory
(defconst my:emacs-config-dir "~/dotfiles/emacs/configs/" "")

;; utility finction to auto-load my package configurations
(defun my:load-config-file (filelist)
  (dolist (file filelist)
    (load (expand-file-name 
	   (concat my:emacs-config-dir file)))
    (message "Loaded config file:%s" file)
    ))

(defconst my:xml-mode 'nxml-mode)

;;Mac-specific changes
(defvar my:osx (eq system-type 'darwin)) 
(when my:osx
  (my:load-config-file '("osx.el")))

(my:load-config-file '("package.el"
		       "org-mode-init.el"
		       "keys.el"
		       "evil.el"
		       "faces.el"
		       "mode-customizations.el"
		       ;;"work.el"
		       "aura.el"
		       "misc-fns.el"
		       ;;"select-cvs.el"
		       "clojure.el"))

(setq inhibit-splash-screen t)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;;Org-mode local customizations:
(setq org-mobile-directory "~/Dropbox/MobileOrg")
(setq org-directory "~/Dropbox/org")

;;Global mode enablement
(global-linum-mode t)
(show-paren-mode t)
(savehist-mode t)
(electric-indent-mode t)
(projectile-global-mode)
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

;;ido
(require 'flx-ido)
(ido-mode t)
(ido-everywhere t)
(flx-ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;;Tramp defaults
(setq tramp-default-method "ssh")
(setq-default indent-tabs-mode nil)

;;Misc
(put 'scroll-left 'disabled nil)

;;Smart mode line
(require 'smart-mode-line)
(sml/setup)
(sml/apply-theme 'light)

;;Eclim - java dev only, put in work?
(require 'eclim)
(require 'eclimd)
(global-eclim-mode)
