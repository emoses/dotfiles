(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/")
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(defvar packages-list '(org
		    clojure-mode
		    nrepl
		    paredit
		    js2-mode
		    evil
		    find-file-in-repository
		    markdown-mode
		    p4
		    magit
		    dired-details+
		    jade-mode
		    less-css-mode
		    projectile
		    flx-ido
		    haskell-mode
		    ack-and-a-half))

(defun install-if-needed (package)
  (unless (package-installed-p package)
    (package-refresh-contents)
    (package-install package)))

(mapc 'install-if-needed packages-list)
