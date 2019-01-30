(defun get-sched (item)
  "An int representation of the Scheduled date, or most-positive-fixnum
if there is no schedule (so these are sorted to the bottom)"
  (let ((sched (org-entry-get (get-text-property 0 'org-hd-marker item) "SCHEDULED")))
    (if sched (org-time-string-to-absolute sched) most-positive-fixnum)))
(defun org-scheduled-cmp (a b)
  (let ((schedA (get-sched a))
        (schedB (get-sched b)))
    (cond ((> schedA schedB) +1)
          ((> schedB schedA) -1)
          (t nil))))


;; Git installation from straight.el
;; from https://github.com/raxod502/straight.el#installing-org-with-straightel
(require 'subr-x)
(straight-use-package 'git)

(defun org-git-version ()
  "The Git version of org-mode.
Inserted by installing org-mode or when a release is made."
  (require 'git)
  (let ((git-repo (expand-file-name
                   "straight/repos/org/" user-emacs-directory)))
    (string-trim
     (git-run "describe"
              "--match=release\*"
              "--abbrev=6"
              "HEAD"))))

(defun org-release ()
  "The release version of org-mode.
Inserted by installing org-mode or when a release is made."
  (require 'git)
  (let ((git-repo (expand-file-name
                   "straight/repos/org/" user-emacs-directory)))
    (string-trim
     (string-remove-prefix
      "release_"
      (git-run "describe"
               "--match=release\*"
               "--abbrev=0"
               "HEAD")))))

(use-package org-plus-contrib
  :mode ("\\.org$" . org-mode)
  :requires (plantuml-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c i" . org-toggle-item)
         ("C-c h" . org-toggle-heading)
         ("C-c r" . org-reveal)
         ("M-q" . org-fill-paragraph))
  :init
  (add-hook 'org-mode-hook 'flyspell-mode)
  :config
  (message "org mode config")
  ;;normally bound to org-reveal, but that's moved to C-c r above
  (define-key org-mode-map (kbd "C-c C-r") nil)

  (setq org-mobile-directory "~/Nextcloud/MobileOrg")
  (setq org-directory "~/Nextcloud/org")
  (setq org-mobile-inbox-for-pull (expand-file-name "from-mobile.org" org-directory))
  (setq org-agenda-files (mapcar (lambda (f) (expand-file-name f org-directory))
                                 '("work.org" "home.org")))
  (add-hook 'org-mode-hook
            (lambda ()
              (org-defkey org-mode-map (kbd "RET") 'org-return-indent)
              (org-defkey org-mode-map "\C-j" 'org-return)
              (display-line-numbers-mode -1)))
  (global-set-key (kbd  "C-c C-`") #'org-cycle-agenda-files)
  (setq org-hide-leading-stars t)
  (setq org-odd-levels-only t)

  (setq org-agenda-cmp-user-defined 'org-scheduled-cmp)

  (if (fboundp 'org-remember-insinuate)
      (org-remember-insinuate))
  (let ((rememberFn (cond
                     ((fboundp 'org-remember) 'org-remember)
                     ((fboundp 'org-capture) 'org-capture)
                     (t nil))))
    (if rememberFn
        (define-key global-map "\C-cr" rememberFn)))

  ;; (if (fboundp 'org-remember-insinuate)
  ;;     (ssorg-remember-insinuate))
  ;; (let ((rememberFn (cond
  ;;                    ((fboundp 'org-remember) 'org-remember)
  ;;                    ((fboundp 'org-capture) 'org-capture)
  ;;                    (t nil))))
  ;;   (if rememberFn
  ;;       (define-key global-map "\C-cr" rememberFn)))

  (setq org-default-notes-file (expand-file-name "notes.org" org-directory))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t)))
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
  (setq org-plantuml-jar-path (expand-file-name "~/lib/plantuml.jar")))

(use-package htmlize)
