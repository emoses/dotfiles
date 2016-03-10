(require 'package)
(setq package-archives `(("gnu" . "https://elpa.gnu.org/packages")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")))

(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)

;(add-to-list 'package-load-list '(magit-gh-pulls "0.5.1"))

(package-initialize)


(defvar packages-list '(org
		    clojure-mode
		    cider
		    rainbow-delimiters
		    paredit
                        evil-paredit
		    js2-mode
		    evil
		    find-file-in-repository
		    markdown-mode
		    p4
		    magit
                    magit-gh-pulls
		    dired-details+
		    jade-mode
		    less-css-mode
		    projectile
		    flx-ido
		    haskell-mode
                        haml-mode
		    ack-and-a-half
                    smart-mode-line
                    emacs-eclim
                    auto-complete
                    google-c-style
                    base16-theme
                    exec-path-from-shell
                    web-mode
                    lua-mode
                    ag
                    flycheck
                    win-switch
                    ido-completing-read+
                    editorconfig
                    typescript-mode))

(let ((uninstalled-packages ;(filter '(lambda (p) (not package-installed-p p)) packages-list)
       (delq nil
	     (mapcar (lambda (x) (and (not (package-installed-p x)) x)) packages-list))))
  (unless (null uninstalled-packages)
    (package-refresh-contents)
    (mapc 'package-install uninstalled-packages)))
