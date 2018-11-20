(require 'package)
(setq package-archives `(("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")))

(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)

;(add-to-list 'package-load-list '(magit-gh-pulls "0.5.1"))

(defvar packages-list '(use-package
                           org
		    rainbow-delimiters
		    dired-details+
		    flx-ido
                    ido-completing-read+
                    editorconfig))

(let ((uninstalled-packages ;(filter '(lambda (p) (not package-installed-p p)) packages-list)
       (delq nil
	     (mapcar (lambda (x) (and (not (package-installed-p x)) x)) packages-list))))
  (unless (null uninstalled-packages)
    (package-refresh-contents)
    (mapc 'package-install uninstalled-packages)))

(eval-when-compile
  (require 'use-package))
