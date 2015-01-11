(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(defvar packages-list '(org
		    clojure-mode
		    cider
		    rainbow-delimiters
		    paredit
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
            auto-complete))

(let ((uninstalled-packages ;(filter '(lambda (p) (not package-installed-p p)) packages-list)
       (delq nil 
	     (mapcar (lambda (x) (and (not (package-installed-p x)) x)) packages-list))))
  (unless (null uninstalled-packages)
    (package-refresh-contents)
    (mapc 'package-install uninstalled-packages)))
