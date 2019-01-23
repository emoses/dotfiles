(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(require 'package)
(setq package-archives `(("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))

(defmacro use-url (name url)
  `(unless (require ',name nil t)
     (with-temp-buffer
       (url-insert-file-contents ,url)
       (eval-buffer)
       (write-file (concat user-emacs-directory
                           (file-name-as-directory "elisp")
                           (concat (symbol-name ',name) ".el"))))))
(use-url quelpa  "https://raw.github.com/quelpa/quelpa/master/bootstrap.el")

(eval-when-compile
  (require 'use-package))

(use-package el-patch
  :config
  (setq el-patch-enable-use-package-integration t))

(require 'el-patch)

(use-package dired-details+)
(use-package flx-ido)
(use-package ido-completing-read+)
(use-package editorconfig)
