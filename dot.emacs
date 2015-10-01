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
    ("4cdea318a3efab7ff7c832daea05f6b2d5d0a18b9bfa79763b674e860ecbc6da" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "75c0b1d2528f1bce72f53344939da57e290aa34bea79f3a1ee19d6808cb55149" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "8022cea21aa4daca569aee5c1b875fbb3f3248a5debc6fc8cf5833f2936fbb22" "a0fdc9976885513b03b000b57ddde04621d94c3a08f3042d1f6e2dbc336d25c7" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" default)))
 '(evil-overriding-maps
   (quote
    ((Buffer-menu-mode-map)
     (color-theme-mode-map)
     (comint-mode-map)
     (compilation-mode-map)
     (grep-mode-map)
     (dictionary-mode-map)
     (ert-results-mode-map . motion)
     (Info-mode-map . motion)
     (speedbar-key-map)
     (speedbar-file-key-map)
     (speedbar-buffers-key-map)
     (cider-popup-buffer-mode-map)
     (cider-stacktrace-mode-map))))
 '(flycheck-disabled-checkers (quote (emacs-lisp-checkdoc)))
 '(flycheck-temp-prefix "__flycheck")
 '(js2-bounce-indent-flag nil)
 '(js2-strict-inconsistent-return-warning nil)
 '(magit-blame-heading-format "%-20a %C %.10H %s")
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
 '(fringe ((t (:background "#373b41" :foreground "#586e75"))))
 '(js2-error-face ((((class color) (background dark)) (:foreground "pale turquoise" :weight bold))))
 '(linum ((t (:background "#282a2e" :foreground "#e0e0e0")))))

;; default xemacs configuration directory
(defconst my:emacs-base "~/dotfiles/emacs/" "Libraries, and the base for configs")
(defconst my:emacs-config-dir (concat my:emacs-base "configs/") "Place that my:load-config-file will look for configs")
(add-to-list 'load-path my:emacs-base)

;; utility finction to auto-load my package configurations
(defun my:load-config-file (filelist)
  (dolist (fileOrFn filelist)
    (let ((file
           (if (functionp fileOrFn)
               (funcall fileOrFn)
             fileOrFn)))
      (when file
        (load (expand-file-name
                (concat my:emacs-config-dir file)))
        (message "Loaded config file:%s" file)))
    ))

(defconst my:xml-mode 'nxml-mode)

;;Mac-specific changes
(defvar my:osx (eq system-type 'darwin))

(my:load-config-file '((lambda () (if my:osx "osx.el" nil))
                       "secrets.el"
                       "gh.el"
                       "package.el"
                       (lambda () (if my:osx "osx-post-init.el" nil))
		       "org-mode-init.el"
		       "evil.el"
		       "faces.el"
		       "mode-customizations.el"
		       "keys.el"
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
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(add-hook 'after-init-hook #'global-flycheck-mode)

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
(setq visible-bell t)

;;Smart mode line
(require 'smart-mode-line)
(sml/setup)
(sml/apply-theme 'light)

;;Eclim - java dev only, put in work?
;(require 'eclim)
;(require 'eclimd)
;(global-eclim-mode)
