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
 '(company-dabbrev-downcase nil)
 '(company-dabbrev-ignore-case nil)
 '(connection-local-criteria-alist
   '(((:application tramp :machine "FK00M29L63")
      tramp-connection-local-darwin-ps-profile)
     ((:application eshell)
      eshell-connection-default-profile)
     ((:application tramp :machine "localhost")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp :machine "C02DR5M6MD6T")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)))
 '(connection-local-profile-alist
   '((eshell-connection-default-profile
      (eshell-path-env-list))
     (tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . tramp-ps-time)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (user . string)
       (group . string)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (ttname . string)
       (time . tramp-ps-time)
       (nice . number)
       (etime . tramp-ps-time)
       (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (group . string)
       (comm . 52)
       (state . string)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . number)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh")
      (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":")
      (null-device . "/dev/null"))))
 '(custom-safe-themes
   '("0b98215401d426a6514f0842193272844002ca70e56b3519ea8fcd0a17f0d0de" "8b9d07b01f2a9566969c2049faf982cab6a4b483dd43de7fd6a016bb861f7762" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "3380a2766cf0590d50d6366c5a91e976bdc3c413df963a0ab9952314b4577299" "4cdea318a3efab7ff7c832daea05f6b2d5d0a18b9bfa79763b674e860ecbc6da" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "75c0b1d2528f1bce72f53344939da57e290aa34bea79f3a1ee19d6808cb55149" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "8022cea21aa4daca569aee5c1b875fbb3f3248a5debc6fc8cf5833f2936fbb22" "a0fdc9976885513b03b000b57ddde04621d94c3a08f3042d1f6e2dbc336d25c7" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "9dae95cdbed1505d45322ef8b5aa90ccb6cb59e0ff26fef0b8f411dfc416c552" "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" default))
 '(evil-overriding-maps
   '((Buffer-menu-mode-map)
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
     (cider-stacktrace-mode-map)))
 '(fill-column 120)
 '(flycheck-disabled-checkers '(emacs-lisp-checkdoc python-pylint))
 '(flycheck-global-modes '(not elisp-mode))
 '(flycheck-temp-prefix "__flycheck")
 '(global-treesit-auto-modes
   '(typescript-mode typescript-ts-mode tsx-ts-mode toml-mode conf-toml-mode toml-ts-mode rust-mode rust-ts-mode ruby-mode ruby-ts-mode ess-mode r-ts-mode python-mode python-ts-mode protobuf-mode protobuf-ts-mode markdown-mode poly-markdown-mode markdown-ts-mode makefile-mode makefile-ts-mode lua-mode lua-ts-mode latex-mode latex-ts-mode kotlin-mode kotlin-ts-mode julia-mode julia-ts-mode js-json-mode json-ts-mode js2-mode javascript-mode js-mode js-ts-mode java-mode java-ts-mode sgml-mode mhtml-mode html-ts-mode heex-mode heex-ts-mode go-mod-mode go-mod-ts-mode go-mode go-ts-mode elixir-mode elixir-ts-mode dockerfile-mode dockerfile-ts-mode css-mode css-ts-mode c++-mode c++-ts-mode common-lisp-mode commonlisp-ts-mode cmake-mode cmake-ts-mode clojure-mode clojure-ts-mode csharp-mode csharp-ts-mode c-mode c-ts-mode bibtex-mode bibtex-ts-mode sh-mode bash-ts-mode))
 '(js2-bounce-indent-flag nil)
 '(js2-global-externs '("require" "module"))
 '(js2-strict-inconsistent-return-warning nil)
 '(lsp-eslint-auto-fix-on-save t)
 '(lsp-imenu-sort-methods '(position kind))
 '(lsp-ui-imenu-auto-refresh t)
 '(lsp-ui-imenu-buffer-position 'left)
 '(lsp-ui-imenu-window-width 60)
 '(mac-auto-operator-composition-characters "!\"#$%&'()+,-./:;<=>?@[]^_`{|}~")
 '(magit-blame-heading-format "%-20a %C %.10H %s")
 '(mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control))))
 '(native-comp-async-report-warnings-errors 'silent)
 '(org-agenda-files nil)
 '(org-export-backends '(ascii html icalendar latex md odt))
 '(org-log-done 'time)
 '(org-modules
   '(org-bbdb org-bibtex org-gnus org-info org-jsinfo org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-mouse))
 '(org-refile-targets '((org-agenda-files :maxlevel . 3)))
 '(package-selected-packages
   '(forge origami lsp-python-ms el-patch company-lsp lsp-ui lsp-mode htmlize emacs-htmlize racket-mode evil-cleverparens scad-mode neotree eldoc-overlay company-flx quelpa-use-package quelpa add-node-modules-path ace-window evil-collection php-mode dockerfile-mode xterm-color pyenv-mode elpy ace-jump-mode evil-org evil-org-mode dired+ plantuml-mode graphql-mode org nlinum evil-leader inf-clojure esup groovy-mode yaml-mode win-switch web-mode typescript-mode smartparens smart-mode-line rainbow-delimiters projectile p4 markdown-mode lua-mode less-css-mode json-mode js2-mode jade-mode ido-completing-read+ haskell-mode haml-mode google-c-style flx-ido find-file-in-repository exec-path-from-shell evil-paredit evil-lispy emacs-eclim elm-mode editorconfig dired-details+ cider base16-theme auto-complete ag ack-and-a-half))
 '(projectile-project-root-files
   '("rebar.config" "project.clj" "build.boot" "deps.edn" "SConstruct" "pom.xml" "build.sbt" "gradlew" "build.gradle" ".ensime" "Gemfile" "requirements.txt" "setup.py" "tox.ini" "composer.json" "Cargo.toml" "mix.exs" "stack.yaml" "info.rkt" "DESCRIPTION" "TAGS" "GTAGS" "configure.in" "configure.ac" "cscope.out" "package.json"))
 '(safe-local-variable-values
   '((backup-directory-alist
      ("." . "~/.emacs.d/backup-files/"))
     (eval turn-on-auto-fill)
     (web-mode-engines-alist
      ("go" . "\\.tpl\\.html"))
     (lsp-enabled-clients deno-ls)
     (org-html-metadata-timestamp-format . "%Y-%m-%d")
     (my:prettify . t)
     (lsp-eslint-package-manager . "yarn")
     (lsp-eslint-working-directories .
                                     ["frontend/"])
     (lsp-eslint-package-manager . yarn)
     (jest-executable . "yarn utest --")
     (projectile-indexing-method quote hybrid)
     (projectile-project-test-suffix . "_spec.js")
     (projectile-project-test-suffix . "_spec")
     (mocha-command . "node_modules/.bin/mocha")
     (mocha-options . "-u bdd --no-timeouts server/lib/testing/bootstrap_js_tests.js")
     (mocha-opts-file . "config/mocha/local.opts")
     (mocha-reporter)
     (projectile-project-test-cmd . "$(npm bin)/mocha -u bdd --no-timeouts --opts config/mocha/local.opts server/lib/testing/bootstrap_js_tests.js")
     (lsp-python-ms-python-executable-cmd . "python3")
     (my:lsp-go-directory-filters .
                                  ["-frontend"])
     (my:lsp-go-directory-filters quote
                                  ("-frontend"))
     (lsp-nested-project-separator)
     (lsp--override-calculate-lisp-indent? . t)
     (lsp-go-gopls-server-args "-rpc.trace" "--debug=localhost:6061" "-logfile=/Users/evanmoses/dev/go/src/github.com/ScaleFT/device-tools/gopls.log")
     (lsp-go-gopls-server-args "-rpc.trace" "--debug=localhost:6060" "-logfile=/Users/evanmoses/dev/go/src/go.sudo.wtf/gopls.log")
     (lsp-go-gopls-server-args "-rpc.trace" "--debug=localhost:6060")
     (flycheck-disabled-checkers quote
                                 (emacs-lisp-checkdoc))
     (eval set
           (make-local-variable '-dirlocal-project-path)
           (when-let
               ((d
                 (dir-locals-find-file ".")))
             (file-name-directory
              (if
                  (stringp d)
                  d
                (car d)))))
     (eval setq flycheck-golangci-lint-config
           (concat -dirlocal-project-path ".golangci.yml"))
     (sql-product . postgres)
     (auto-save-file-name-transforms
      ("." "~/dev/.go.sudo.wtf~/frontend/" t))
     (backup-directory-alist
      ("." . "~/dev/.go.sudo.wtf~/frontend/"))
     (projectile-indexing-method . hybrid)
     (auto-save-file-name-transforms quote
                                     (("." "~/dev/.go.sudo.wtf~/frontend" t)))
     (backup-directory-alist quote
                             (("." . "~/dev/.go.sudo.wtf~/frontend")))
     (jest-executable . "yarn utest")
     (checkdoc-package-keywords-flag)
     (eval font-lock-add-keywords nil
           `((,(concat "("
                       (regexp-opt
                        '("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op" "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl")
                        t)
                       "\\_>")
              1 'font-lock-variable-name-face)))
     (projectile-project-type quote go)
     (eval set
           (make-local-variable 'my-project-path)
           (if-let
               ((root
                 (projectile-project-root)))
               root
             (if-let
                 ((dir-local-root
                   (file-name-directory
                    (let
                        ((d
                          (dir-locals-find-file ".")))
                      (if
                          (stringp d)
                          d
                        (car d))))))
                 dir-local-root)
             nil))
     (eval setq lsp-clients-typescript-server-args
           (list "--stdio" "--log-level 3" "--tsserver-log-file /Users/evanmoses/tsserver-log.txt"
                 (concat "--tsserver-path "
                         (file-name-as-directory my-project-path)
                         "node_modules/.bin/tsserver")))
     (eval setq lsp-clients-typescript-server-args
           (list "--stdio"
                 (concat "--tsserver-path "
                         (file-name-as-directory my-project-path)
                         "node_modules/.bin/tsserver")))
     (eval setq lsp-clients-typescript-server-args
           (list "--stdio"
                 (concat
                  (file-name-as-directory my-project-path)
                  "node_modules/.bin/tsserver")))
     (eval setq lsp-clients-typescript-server-args
           (list "--stdio"
                 (concat
                  (file-name-as-directory my-project-path)
                  "node_modules/.bin/tsserver" my-project-path)))
     (eval progn
           (set
            (make-local-variable my-project-path)
            (file-name-directory
             (let
                 ((d
                   (dir-locals-find-file ".")))
               (if
                   (stringp d)
                   d
                 (car d)))))
           (let
               ((tsserver-path
                 (concat
                  (file-name-as-directory my-project-path)
                  "node_modules/.bin/tsserver" my-project-path)))
             (setq lsp-clients-typescript-server-args
                   (list "--stdio" tsserver-path))))
     (eval setq
           (make-local-variable my-project-path)
           (file-name-directory
            (let
                ((d
                  (dir-locals-find-file ".")))
              (if
                  (stringp d)
                  d
                (car d)))))
     (eval let
           ((tsserver-path
             (concat
              (file-name-as-directory my-project-path)
              "node_modules/.bin/tsserver" my-project-path)))
           (setq lsp-clients-typescript-server-args
                 (list "--stdio" tsserver-path)))
     (eval set
           (make-local-variable my-project-path)
           (file-name-directory
            (let
                ((d
                  (dir-locals-find-file ".")))
              (if
                  (stringp d)
                  d
                (car d)))))
     (delete-old-versions . t)
     (backup-by-copying . t)
     (create-lockfiles)
     (add-node-modules-path-command "yarn bin")))
 '(sml/mode-width (if (eq (powerline-current-separator) 'arrow) 'right 'full))
 '(sml/name-width 44)
 '(sml/pos-id-separator
   '(""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " " 'display
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (car powerline-default-separator-dir)))
                   'powerline-active1 'powerline-active2)))
     (:propertize " " face powerline-active2)))
 '(sml/pos-minor-modes-separator
   '(""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " " 'display
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (cdr powerline-default-separator-dir)))
                   'powerline-active1 'sml/global)))
     (:propertize " " face sml/global)))
 '(sml/pre-id-separator
   '(""
     (:propertize " " face sml/global)
     (:eval
      (propertize " " 'display
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (car powerline-default-separator-dir)))
                   'sml/global 'powerline-active1)))
     (:propertize " " face powerline-active1)))
 '(sml/pre-minor-modes-separator
   '(""
     (:propertize " " face powerline-active2)
     (:eval
      (propertize " " 'display
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (cdr powerline-default-separator-dir)))
                   'powerline-active2 'powerline-active1)))
     (:propertize " " face powerline-active1)))
 '(sml/pre-modes-separator (propertize " " 'face 'sml/modes))
 '(sml/replacer-regexp-list
   '(("^~/ownCloud/org" ":Org:")
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
     ("~/dev/patreon/" ":WORK:")))
 '(sml/shorten-directory nil)
 '(tls-checktrust t)
 '(undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree-history")))
 '(warning-suppress-types '((copilot copilot-exceeds-max-char)))
 '(xref-prompt-for-identifier
   '(not xref-find-definitions xref-find-definitions-other-window xref-find-definitions-other-frame xref-find-references)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:foreground "red" :height 4.0))))
 '(ediff-even-diff-C ((t (:background "light grey" :foreground "black"))))
 '(ediff-odd-diff-C ((t (:background "Grey" :foreground "black"))))
 '(flycheck-color-mode-line-info-face ((t (:foreground "dim gray"))))
 '(flycheck-color-mode-line-success-face ((t (:foreground "dark green"))))
 '(fringe ((t (:background "#373b41" :foreground "#586e75"))))
 '(highlight ((t (:background "#41444a" :inverse-video nil))))
 '(js2-error-face ((((class color) (background dark)) (:foreground "pale turquoise" :weight bold))))
 '(line-number-current-line ((t (:background "#969896" :foreground "#3b3e44"))))
 '(linum ((t (:background "#282a2e" :foreground "#e0e0e0"))))
 '(lsp-ui-sideline-global ((t (:background "medium blue"))))
 '(magit-diff-file-heading ((t (:background "selectedTextBackgroundColor" :foreground "selectedTextColor"))))
 '(magit-diff-file-heading-highlight ((t (:background "selectedContentBackgroundColor" :foreground "selectedTextColor" :weight bold))))
 '(sml/global ((t (:background "grey85" :foreground "grey20" :inverse-video nil :weight semi-light :height 1.05 :family "Avenir")))))

(defconst my:emacs-base "~/dotfiles/emacs/" "Libraries, and the base for configs")
(defconst my:emacs-config-dir (concat my:emacs-base "configs/") "Place that my:load-config-file will look for configs")

;WTF why does the debugger randomly get turned on?
;; (add-variable-watcher 'debug-on-error (lambda (symbol newval op where)
;;                                         (when newval
;;                                           (debug--implement-debug-watch symbol newval op where))))

(add-to-list 'load-path my:emacs-base)
(add-to-list 'load-path (concat user-emacs-directory "elisp"))


;;Performance tuning (see https://github.com/emacs-lsp/lsp-mode#performance)
(setq gc-cons-threshold (* 100 1024 1024))
(setq read-process-output-max (* 1024 1024))

(setq initial-scratch-message nil)

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
(defvar my:linux (eq system-type 'gnu/linux))

(when my:osx
  (require 'auth-source)
  (add-to-list 'auth-sources 'macos-keychain-generic)
  (add-to-list 'auth-sources 'macos-keychain-internet))

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

(setq okta t)

(my:load-config-file '("package-bootstrap.el"
		       (lambda () (if my:osx "osx.el" nil))
                       "secrets.el"
                       "gh.el"
		       "org-mode-init.el"
		       "evil.el"
		       "faces.el"
		       "mode-customizations.el"
                       "hugo-markdown-mode.el"
                       "javascript.el"
		       "keys.el"
		       "misc-fns.el"
                       "ai.el"
		       "clojure.el"
                       "lsp.el"
                       "python.el"
                       "present-minor-mode.el"
                       "go.el"
                       "okta.el"))

;;Random options
(put 'narrow-to-region 'disabled nil)
(setq create-lockfiles nil)
(setq inhibit-splash-screen t)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(setq default-frame-alist
      '((width . 250)
        (height . 70)))
(setq fill-column 120)
(setq split-width-threshold 200)
(setq help-window-select t)
;;New in Emacs 28
(when (>= emacs-major-version 28)
  (setq next-error-message-highlight t)
  (setq read-minibuffer-restore-windows nil)
  (setq dired-kill-when-opening-new-dired-buffer t)
  (setq completions-detailed t))

(setq compilation-scroll-output t)

;;Global mode enablement
(show-paren-mode t)
(savehist-mode t)
(electric-indent-mode t)

;;New stuff for emacs 26
(when (>= emacs-major-version 26)
  (if (fboundp 'pixel-scroll-precision-mode)
      (pixel-scroll-precision-mode)
      (pixel-scroll-mode))
  (setq mouse-wheel-tilt-scroll t)
  (setq mouse-wheel-flip-direction t)
  (setq display-line-numbers-width-start 3)
  (setq display-line-numbers-grow-only t)
  (global-display-line-numbers-mode t))

(when (< emacs-major-version 26)
  (use-package nlinum
    :config
    (defun my:nlinum-hook-min-lines ()
      (when (fboundp 'nlinum-mode)
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
  :bind (("C-c C-s" . my:projectile-ag-symbol))
  :config
  (setq projectile-completion-system 'ivy)
  (setq projectile-switch-project-action #'projectile-find-file-dwim)
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "A-p") 'projectile-command-map)
  (define-key projectile-command-map (kbd "s t") #'my:projectile-ag-test)
  (define-key projectile-command-map (kbd "C") #'projectile-go-compile-tests)

  (defun my:projectile-test-root ()
      (let* ((project-root (projectile-project-root))
             (test-dir-name (or  (projectile-project-type-attribute (projectile-project-type) 'test-dir) ".")))
        (expand-file-name test-dir-name project-root)))

  (defun projectile-go-compile-tests ()
    (interactive)
    (if (not (eq (projectile-project-type) 'go))
        (message "Not a go project")
      (let ((compilation-read-command nil)
            (compile-command "go test -run=none ./..."))
        (projectile--run-project-cmd compile-command nil
                                     :save-buffers t))))

  (defun my:projectile-ag-test (search-term &optional arg)
    "Run an ag search starting at the test root

Largely a copy-paste of projectile-ag, need to refactor"
    (interactive
     (list (projectile--read-search-string-with-default
            (format "Ag %ssearch tests for" (if current-prefix-arg "regexp " "")))
           current-prefix-arg))
    (if (require 'ag nil 'noerror)
        (let ((ag-ignore-list (delq nil
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
              (current-prefix-arg nil)
              ;; TODO prefix
              (suffix (projectile-test-suffix (projectile-project-type))))
          (ag/search search-term (my:projectile-test-root) :regexp arg :file-regex suffix))
      (error "Package 'ag' is not available")))

  ;; WIP, needs to turn into a real glob
  (defun my:projectile-ripgrep-test (search-term &optional arg)
    "Run a Ripgrep search with `SEARCH-TERM' at current project root.

With an optional prefix argument ARG SEARCH-TERM is interpreted as a
regular expression."
    (interactive
     (list (projectile--read-search-string-with-default
            (format "Ripgrep %ssearch tests for" (if current-prefix-arg "regexp " "")))
           current-prefix-arg))
    (if (require 'ripgrep nil 'noerror)
        (let* ((args (mapcar (lambda (val) (concat "--glob !" val))
                             (append projectile-globally-ignored-files
                                     projectile-globally-ignored-directories)))
               (suffix (projectile-test-suffix (projectile-project-type)))
               (args (append args (list (concat  "--glob '" suffix "*'")))))
          (ripgrep-regexp search-term
                          (my:projectile-test-root)
                          (if arg
                              args
                            (cons "--fixed-strings" args))))
      (error "Package `ripgrep' is not available")))

  (defun my:projectile-ag-symbol (search-term &optional arg)
    "Run an ag search for symbol at point, or region if active.

With optional prefix ARG, SEARCH-TERM is treated as a regexp"
    (interactive
     (list
      (let ((symbol
             (if (use-region-p)
                 (buffer-substring-no-properties (region-beginning)
                                                 (region-end))
               (thing-at-point 'symbol))))
        (if (and symbol (not current-prefix-arg))
            symbol
          (projectile--read-search-string-with-default
           (format "Search in project for %s: " (if current-prefix-arg "regexp" "string")))))
      current-prefix-arg))
    (projectile-ag search-term arg)))


(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

(use-package flycheck
  :bind (:map flycheck-mode-map
              ("<f6>" . flycheck-next-error)
              ("S-<f6>" . flycheck-previous-error))
  :init
  (global-flycheck-mode t)
  :config
  (add-hook 'flycheck-mode-hook (lambda ()
                                  (when-let ((local-eslint (find-executable-in-node-modules "eslint")))
                                    (setq-local flycheck-javascript-eslint-executable local-eslint)))))

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
  :bind (("M-x" . counsel-M-x)
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

(require 'transient)

(defun my:transient-with-keyprefix (key desc cmd &rest args)
  (let ((seq (where-is-internal cmd isearch-mode-map)))
    (append (list key
                  (if seq (concat desc "[" (mapconcat #'key-description seq ", ") "]")
                    desc)
                  cmd)
            args)))

(transient-define-prefix my:isearch-menu ()
  "isearch Menu, see
http://yummymelon.com/devnull/improving-emacs-isearch-usability-with-transient.html "
  [["Edit Search String"
    ("e"
     "Edit the search string (recursive)"
     isearch-edit-string
     :transient nil)
    ("w"
     "Pull next word or character word from buffer"
     isearch-yank-word-or-char
     :transient nil)
    ("s"
     "Pull next symbol or character from buffer"
     isearch-yank-symbol-or-char
     :transient nil)
    ("l"
     "Pull rest of line from buffer"
     isearch-yank-line
     :transient nil)
    ("y"
     "Pull string from kill ring"
     isearch-yank-kill
     :transient nil)
    ("t"
     "Pull thing from buffer"
     isearch-forward-thing-at-point
     :transient nil)]

   ["Replace"
    ("q"
     "Start ‘query-replace’"
     isearch-query-replace
     :if-nil buffer-read-only
     :transient nil)
    ("x"
     "Start ‘query-replace-regexp’"
     isearch-query-replace-regexp
     :if-nil buffer-read-only
     :transient nil)]]

  [["Toggle"
    ("X"
     "Toggle regexp searching"
     isearch-toggle-regexp
     :transient nil)
    ("S"
     "Toggle symbol searching"
     isearch-toggle-symbol
     :transient nil)
    ("W"
     "Toggle word searching"
     isearch-toggle-word
     :transient nil)
    ("F"
     "Toggle case fold"
     isearch-toggle-case-fold
     :transient nil)
    ("L"
     "Toggle lax whitespace"
     isearch-toggle-lax-whitespace
     :transient nil)]

   ["Misc"
    ("o"
     "occur"
     isearch-occur
     :transient nil)]])

(define-key isearch-mode-map (kbd "A-s") 'my:isearch-menu)


(use-package ivy-hydra
  :after (ivy hydra))

(use-package ag
  :bind (("A-s" . 'ag)
          ("A-S" . 'ag-regexp)
          ;;On Macos A-S-s will send §
          ("§" . 'ag-regexp))
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

(use-package ripgrep)

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
(use-package flycheck-color-mode-line
  :hook (flycheck-mode . flycheck-color-mode-line-mode)
  :config
  (setq flycheck-color-mode-line-face-to-color 'sml/filename))

(use-package ace-jump-mode)

(use-package ace-window
  :bind ("M-SPC" . ace-window))

(use-package help-fns+)

;; (use-package neotree
;;   :bind ("M-\\" . neotree-toggle)
;;   :after (projectile)
;;   :config
;;   (setq neo-smart-open t))

(use-package zoom-frm
  :bind (("C-x C--" . zoom-in/out)
         ("C-x C-=" . zoom-in/out)
         ("C-x C-0" . zoom-in/out)
         ("C-x C-+" . zoom-in/out)
         ([C-S-wheel-right] . zoom-out)
         ([C-S-wheel-left] . zoom-in)))

(use-package yasnippet
  :bind (("C-'" . my:accept-completion)
         :map yas-keymap
         ([tab] . nil)
         ([backtab] . nil)
         ("TAB" . nil)
         ([(shift tab)] . nil)
         ("C-o" . yas-next-field-or-maybe-expand)
         ("C-S-o" . yas-prev-field))
  :config
  (defun my:accept-completion ()
    (interactive)
    (or
     (and (fboundp 'copilot-accept-completion) (copilot-accept-completion))
     (yas-expand)))
  (yas-global-mode t))

(use-package yasnippet-snippets)

(use-package treemacs
  :init
  (setq treemacs-width 50)
  :config
  (setq treemacs-space-between-root-nodes nil)
  (treemacs-resize-icons 16)
  (add-hook 'treemacs-mode-hook (lambda () (text-scale-set -1))))

(use-package treemacs-projectile
  :after treemacs)

(projectile-mode +1)

(use-package edit-server
  :bind (:map edit-server-edit-mode-map
              ("C-c C-q" . edit-server-abort))
  :commands edit-server-start
  :init (if after-init-time
            (edit-server-start)
          (add-hook 'after-init-hook #'edit-server-start))
  :custom (edit-server-url-major-mode-alist . ('(("^github.com" . markdown-mode)))))

(use-package keychain-environment
   :if my:linux
   :init
   (keychain-refresh-environment))

;; Display buffer

(add-to-list 'display-buffer-alist
             `(,(make-display-buffer-matcher-function '(compilation-mode))
               (display-buffer-reuse-window)
               (inhibit-same-window . t)))
(add-to-list 'display-buffer-alist
             '("\\*gud-test\\*"
               (display-buffer-use-some-window)
               (inhibit-same-window . t) ))
(put 'scroll-left 'disabled nil)

;; (defun -debug-delete-windows (win param val)
;;   (when (and  (eq param 'no-delete-other-windows) val)
;;     (debug)))
;; (advice-add 'set-window-parameter :before #'-debug-delete-windows)
(put 'magit-clean 'disabled nil)
