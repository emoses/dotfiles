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

(use-package org
  :quelpa t
  :mode ("\\.org$" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c i" . org-toggle-item)
         ("C-c h" . org-toggle-heading)
         ("C-c r" . org-reveal)
         ("M-q" . org-fill-paragraph))
  :init
  (add-hook 'org-mode-hook 'flyspell-mode)
  :config
  (require 'org-install)
  ;;normally bound to org-reveal, but that's moved to C-c r above
  (define-key org-mode-map (kbd "C-c C-r") nil)

  (setq org-mobile-directory "~/Nextcloud/MobileOrg")
  (setq org-directory "~/Nextcloud/org")
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
  ;;     (org-remember-insinuate))
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

(use-package htmlize
  :ensure t)
