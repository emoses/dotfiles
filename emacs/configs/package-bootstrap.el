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

;; (require 'package)
;; (setq package-archives `(("melpa-stable" . "https://stable.melpa.org/packages/")
;;                          ("melpa" . "https://melpa.org/packages/")
;;                          ("gnu" . "https://elpa.gnu.org/packages/")))

;; Org-mode Git installation from straight.el
;; from https://github.com/raxod502/straight.el#installing-org-with-straightel
;;;
;; (require 'subr-x)
;; (straight-use-package 'git)

;; (defun org-git-version ()
;;   "The Git version of org-mode.
;; Inserted by installing org-mode or when a release is made."
;;   (require 'git)
;;   (let ((git-repo (expand-file-name
;;                    "straight/repos/org/" user-emacs-directory)))
;;     (string-trim
;;      (git-run "describe"
;;               "--match=release\*"
;;               "--abbrev=6"
;;               "HEAD"))))


;; (defun org-release ()
;;   "The release version of org-mode.
;; Inserted by installing org-mode or when a release is made."
;;   (require 'git)
;;   (let ((git-repo (expand-file-name
;;                    "straight/repos/org/" user-emacs-directory)))
;;     (string-trim
;;      (string-remove-prefix
;;       "release_"
;;       (git-run "describe"
;;                "--match=release\*"
;;                "--abbrev=0"
;;                "HEAD")))))

;; (provide 'org-version)

;;; =====

(defmacro use-url (name url)
  `(unless (require ',name nil t)
     (with-temp-buffer
       (url-insert-file-contents ,url)
       (eval-buffer)
       (write-file (concat user-emacs-directory
                           (file-name-as-directory "elisp")
                           (concat (symbol-name ',name) ".el"))))))

;; (use-package el-patch
;;   :config
;;   (setq el-patch-enable-use-package-integration t))

;; (require 'el-patch)

(use-package dired-details+
  :straight (:host github :repo "emacsmirror/dired-details-plus"))
(use-package flx-ido)
(use-package ido-completing-read+)
(use-package editorconfig)

;; Needed until straight's elpa bumps spinner version
(use-package spinner
  :straight (:host github :repo "malabarba/spinner.el"))
