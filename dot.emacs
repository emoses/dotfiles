;;; -*- mode: emacs-lisp -*-
;;; Evan Moses .emacs
;;; Feel free to copy

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-sources
   (quote
    (macos-keychain-generic macos-keychain-internet "~/.authinfo.gpg" "~/.authinfo" "~/.netrc")))
 '(custom-safe-themes
   (quote
    ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "3380a2766cf0590d50d6366c5a91e976bdc3c413df963a0ab9952314b4577299" "4cdea318a3efab7ff7c832daea05f6b2d5d0a18b9bfa79763b674e860ecbc6da" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "75c0b1d2528f1bce72f53344939da57e290aa34bea79f3a1ee19d6808cb55149" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "8022cea21aa4daca569aee5c1b875fbb3f3248a5debc6fc8cf5833f2936fbb22" "a0fdc9976885513b03b000b57ddde04621d94c3a08f3042d1f6e2dbc336d25c7" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" default)))
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
 '(flycheck-disabled-checkers (quote (emacs-lisp-checkdoc python-pylint)))
 '(flycheck-temp-prefix "__flycheck")
 '(js2-bounce-indent-flag nil)
 '(js2-global-externs (quote ("require" "module")))
 '(js2-strict-inconsistent-return-warning nil)
 '(lsp-imenu-sort-methods (quote (position kind)))
 '(mac-auto-operator-composition-characters "!\"#$%&'()+,-./:;<=>?@[]^_`{|}~")
 '(magit-blame-heading-format "%-20a %C %.10H %s")
 '(magit-gh-pulls-arguments (quote ("--open-new-in-browser")))
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 1) ((control)))))
 '(org-agenda-files (quote ("/Users/emoses/Nextcloud/org/home.org")))
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
 '(org-log-done (quote time))
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-mouse)))
 '(org-refile-targets (quote ((org-agenda-files :maxlevel . 3))))
 '(package-selected-packages
   (quote
    (forge origami lsp-python-ms el-patch company-lsp lsp-ui lsp-mode htmlize emacs-htmlize racket-mode evil-cleverparens scad-mode neotree eldoc-overlay company-flx quelpa-use-package quelpa add-node-modules-path ace-window evil-collection php-mode dockerfile-mode xterm-color pyenv-mode elpy ace-jump-mode evil-org evil-org-mode dired+ plantuml-mode graphql-mode org nlinum evil-leader inf-clojure esup groovy-mode yaml-mode win-switch web-mode typescript-mode smartparens smart-mode-line rainbow-delimiters projectile p4 markdown-mode magit-gh-pulls lua-mode less-css-mode json-mode js2-mode jade-mode ido-completing-read+ haskell-mode haml-mode google-c-style flx-ido find-file-in-repository exec-path-from-shell evil-paredit evil-lispy emacs-eclim elm-mode editorconfig dired-details+ cider base16-theme auto-complete ag ack-and-a-half)))
 '(python-pytest-arguments (quote ("--color")) t)
 '(python-pytest-executable "devx pytest" t)
 '(python-pytest-shell-startfile "~/.bashrc" t)
 '(safe-local-variable-values
   (quote
    ((auto-save-file-name-transforms
      ("." "~/dev/patreon/.patreon_py~/" t))
     (backup-directory-alist
      ("." . "~/dev/patreon/.patreon_py~/"))
     (delete-old-versions . t)
     (auto-save-file-name-transforms quote
                                     ((".*" "~/dev/patreon/.patreon_py~/" t)))
     (backup-directory-alist quote
                             ((".*" . "~/dev/patreon/.patreon_py~/")))
     (backup-by-copying . t)
     (python-shell-intepreter-args . "-i --profile=devx --simple-prompt")
     (python-shell-interpreter . "devx-ipython")
     (create-lockfiles))))
 '(sml/mode-width
   (if
       (eq
        (powerline-current-separator)
        (quote arrow))
       (quote right)
     (quote full)))
 '(sml/name-width 44)
 '(sml/pos-id-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (car powerline-default-separator-dir)))
                   (quote powerline-active1)
                   (quote powerline-active2))))
     (:propertize " " face powerline-active2))))
 '(sml/pos-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (cdr powerline-default-separator-dir)))
                   (quote powerline-active1)
                   (quote sml/global))))
     (:propertize " " face sml/global))))
 '(sml/pre-id-separator
   (quote
    (""
     (:propertize " " face sml/global)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (car powerline-default-separator-dir)))
                   (quote sml/global)
                   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active2)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (cdr powerline-default-separator-dir)))
                   (quote powerline-active2)
                   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-modes-separator (propertize " " (quote face) (quote sml/modes)))
 '(sml/replacer-regexp-list
   (quote
    (("^~/ownCloud/org" ":Org:")
     ("^~/\\.emacs\\.d/elpa/" ":ELPA:")
     ("^~/\\.emacs\\.d/" ":ED:")
     ("^/sudo:.*:" ":SU:")
     ("^~/Documents/" ":Doc:")
     ("^~/Dropbox/" ":DB:")
     ("^:\\([^:]*\\):Documento?s/" ":\\1/Doc:")
     ("^~/[Gg]it/" ":Git:")
     ("^~/[Gg]it[Hh]ub/" ":Git:")
     ("^~/[Gg]it\\([Hh]ub\\|\\)-?[Pp]rojects/" ":Git:")
     ("^.*/patreon_py/" ":P_PY:")
     ("~/dev/patreon/" ":WORK:"))))
 '(sml/shorten-directory nil)
 '(tls-checktrust t)
 '(xref-prompt-for-identifier
   (quote
    (not xref-find-definitions xref-find-definitions-other-window xref-find-definitions-other-frame xref-find-references))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:foreground "red" :height 4.0))))
 '(ediff-even-diff-C ((t (:background "light grey" :foreground "black"))))
 '(ediff-odd-diff-C ((t (:background "Grey" :foreground "black"))))
 '(fringe ((t (:background "#373b41" :foreground "#586e75"))))
 '(highlight ((t (:background "#41444a" :inverse-video nil))))
 '(js2-error-face ((((class color) (background dark)) (:foreground "pale turquoise" :weight bold))))
 '(line-number-current-line ((t (:background "#969896" :foreground "#3b3e44"))))
 '(linum ((t (:background "#282a2e" :foreground "#e0e0e0"))))
 '(lsp-ui-sideline-global ((t (:background "medium blue")))))

(defconst my:emacs-base "~/dotfiles/emacs/" "Libraries, and the base for configs")
(defconst my:emacs-config-dir (concat my:emacs-base "configs/") "Place that my:load-config-file will look for configs")
(add-to-list 'load-path my:emacs-base)
(add-to-list 'load-path (concat user-emacs-directory "elisp"))

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
(defvar my:windows (eq system-type 'windows-nt))

;;Deal with TLS certs.  See https://glyph.twistedmatrix.com/2015/11/editor-malware.html
(let ((trustfile
       (replace-regexp-in-string
        "\\\\" "/"
        (replace-regexp-in-string
         "\n" ""
         (shell-command-to-string "python -m certifi")))))
  (setq tls-program
        (list
         (format "gnutls-cli%s --x509cafile %s -p %%p %%h"
                 (if (eq window-system 'w32) ".exe" "") trustfile))))

(my:load-config-file '("package-bootstrap.el"
		       (lambda () (if my:osx "osx.el" nil))
                       "secrets.el"
                       "gh.el"
		       "org-mode-init.el"
		       "evil.el"
		       "faces.el"
		       "mode-customizations.el"
		       "keys.el"
		       "misc-fns.el"
		       "clojure.el"
                       "python.el"
                       "present-minor-mode.el"
                       "go.el"))

(put 'narrow-to-region 'disabled nil)
(setq create-lockfiles nil)
(setq inhibit-splash-screen t)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (and my:osx ))
(setq default-frame-alist
      '((width . 250)
        (height . 70)))
(setq fill-column 120)
(setq help-window-select t)
(setq ispell-program-name "/usr/local/bin/aspell")

;;Global mode enablement
(show-paren-mode t)
(savehist-mode t)
(electric-indent-mode t)

;;New stuff for emacs 26
(when (>= 26 emacs-major-version)
  (pixel-scroll-mode)
  (setq mouse-wheel-tilt-scroll t)
  (setq mouse-wheel-flip-direction t)
  (setq display-line-numbers-width-start 3)
  (setq display-line-numbers-grow-only t)
  (global-display-line-numbers-mode t))

(when (< 26 emacs-major-version)
  (use-package nlinum
    :config
    (defun my:nlinum-hook-min-lines ()
      (when nlinum-mode
        (let* ((approx-lines (ceiling (log (max 1 (/ (buffer-size) 80)) 10)))
               (lineno-width (max 3 approx-lines)))
          (setq-local nlinum-format
                      (concat "%" (number-to-string lineno-width) "d")))))
    (add-hook 'nlinum-mode-hook #'my:nlinum-hook-min-lines)
    (global-nlinum-mode t)))

(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package projectile
  :bind ("C-c p s t" . my:projectile-ag-test)
  :config
  (setq projectile-completion-system 'ivy)
  (setq projectile-switch-project-action #'projectile-find-file-dwim)
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "A-p") 'projectile-command-map)

  (defun my:projectile-test-root ()
      (let* ((project-root (projectile-project-root))
             (test-dir-name (projectile-test-directory (projectile-project-type))))
        (expand-file-name test-dir-name project-root)))

  (defun my:projectile-ag-test (search-term &optional arg)
    "Run an ag search starting at the test root

Largely a copy-paste of projectile-ag, need to refactor"
    (interactive
     (list (projectile--read-search-string-with-default
            (format "Ag %ssearch tests for" (if current-prefix-arg "regexp " "")))
           current-prefix-arg))
    (if (require 'ag nil 'noerror)
        (let ((ag-command (if arg 'ag-regexp 'ag))
              (ag-ignore-list (delq nil
                                    (delete-dups
                                     (append
                                      ag-ignore-list
                                      (projectile--globally-ignored-file-suffixes-glob)
                                      ;; ag supports git ignore files directly
                                      (unless (eq (projectile-project-vcs) 'git)
                                        (append (projectile-ignored-files-rel)
                                                (projectile-ignored-directories-rel)
                                                grep-find-ignored-files
                                                grep-find-ignored-directories
                                                '()))))))
              ;; reset the prefix arg, otherwise it will affect the ag-command
              (current-prefix-arg nil))
          (funcall ag-command search-term (my:projectile-test-root)))
      (error "Package 'ag' is not available"))))


(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

(use-package flycheck
  :config
  (global-flycheck-mode t))

;;ido
;; (use-package flx-ido
;;              :config
;;              (progn
;;                (ido-mode t)
;;                (ido-everywhere t)
;;                (flx-ido-mode t)
;;                (setq ido-enable-flex-matching t)
;;                (setq ido-use-faces nil)
;;                (setq ido-create-new-buffer 'always)))

;; (use-package ido-completing-read+)

(use-package counsel
  :bind (("C-s" . swiper)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-x b" . ivy-switch-buffer)
         ("C-h f" . counsel-describe-function)
         ("C-h v" . counsel-describe-variable)
         :map ivy-minibuffer-map
         ([remap previous-line] . my:previous-line-or-history)
         ("C-c RET" . ivy-immediate-done)
         :map counsel-find-file-map
         ("C-x C-f" . find-file))

  :init
  (add-hook 'after-init-hook
            (lambda ()
              (setq ivy-re-builders-alist
                    '((counsel-M-x . ivy--regex-fuzzy)
                      (t . ivy--regex-fuzzy)))))
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  ; I don't know why, but this doesn't seem to work if I just do it in this :config
  (add-to-list 'ivy-initial-inputs-alist '(counsel-M-x . ""))

  ; Backspace at beginning in minibuffer quits by default.  Don't do that.
  (setq ivy-on-del-error-function #'ignore)
  (defun my:previous-line-or-history (arg)
    (interactive "p")
    (when (zerop ivy--index)
      (ivy-previous-history-element 1))
    (ivy-previous-line arg)))

(use-package hydra
  :config
  (defhydra hydra-next-error
    (global-map "C-x")
    "
Compilation errors:
_j_: next error        _h_: first error    _q_uit
_k_: previous error    _l_: last error
"
    ("`" next-error     nil)
    ("j" next-error     nil :bind nil)
    ("k" previous-error nil :bind nil)
    ("h" first-error    nil :bind nil)
    ("l" (condition-case err
	     (while t
	       (next-error))
	   (user-error nil))
     nil :bind nil)
    ("q" nil            nil :color blue)))

(use-package ivy-hydra
  :after (ivy hydra))

(use-package ag
  :config
  (defun eshell/ag (string)
    (ag/search string (eshell/pwd)))

  (defun ag-kill-all-buffers ()
    (interactive)
    (mapc (lambda (buff)
	    (let ((name (buffer-name buff)))
	      (when (string-prefix-p "*ag search " name)
		(kill-buffer buff))))
	  (buffer-list))))

(use-package find-file-in-repository)

(use-package exec-path-from-shell
  :config
  (when my:osx
					;(add-to-list 'exec-path-from-shell-arguments "--norc")
    (exec-path-from-shell-initialize)))


;;Tramp defaults
(setq tramp-default-method "ssh")
(setq-default indent-tabs-mode nil)

;;Misc
(put 'scroll-left 'disabled nil)
;;Visible-bell causes problems in OSX, so blink the mode-line instead
(setq visible-bell nil)
(setq ring-bell-function
      (lambda ()
	(invert-face 'mode-line)
	(run-with-timer 0.1 nil #'invert-face 'mode-line)))

(use-package powerline
  :config
  (powerline-default-theme))
(use-package smart-mode-line-powerline-theme)
;;Smart mode line
(use-package smart-mode-line
  :after (smart-mode-line-powerline-theme powerline)
  :config
  (sml/apply-theme 'smart-mode-line-light-powerline)
  (sml/setup)
  (set-face-attribute 'mode-line-inactive nil :box '(:width -1)))

(use-package ace-jump-mode)

(use-package ace-window
  :bind ("M-SPC" . ace-window))

(use-url help-fns+ "https://raw.githubusercontent.com/emacsmirror/help-fns-plus/master/help-fns%2B.el")

(use-package neotree
  :bind ("M-\\" . neotree-toggle)
  :after (projectile)
  :config
  (setq neo-smart-open t))

(use-package zoom-frm
  :bind (("C-x C--" . zoom-in/out)
	 ("C-x C-=" . zoom-in/out)
	 ("C-x C-0" . zoom-in/out)
	 ("C-x C-+" . zoom-in/out)
	 ([C-S-wheel-right] . zoom-out)
	 ([C-S-wheel-left] . zoom-in)))

(use-package terminal-here
  :bind (("C-<f2>" . terminal-here-launch)
         ("C-S-<f2>" . terminal-here-project-launch)))

(projectile-mode +1)
