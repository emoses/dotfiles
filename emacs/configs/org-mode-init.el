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
  :ensure t
  :mode ("\\.org$" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c i" . org-toggle-item)
         ("C-c h" . org-toggle-heading))
  :config
  (setq org-mobile-directory "~/ownCloud/MobileOrg")
  (setq org-directory "~/ownCloud/org")
  (when (eq system-type 'windows-nt)
    (setq org-mobile-checksum-binary "d:/program files/gnu/sha1sum.exe"))
  (require 'org-install)
  (add-hook 'org-mode-hook
            (lambda ()
              (org-defkey org-mode-map (kbd "RET") 'org-return-indent)
              (org-defkey org-mode-map "\C-j" 'org-return)))
  (setq org-hide-leading-stars t)
  (setq org-odd-levels-only t)

  (setq org-agenda-cmp-user-defined 'org-scheduled-cmp)

  (defvar org-directory "")
  (if (fboundp 'org-remember-insinuate)
      (org-remember-insinuate))
  (let ((rememberFn (cond
                     ((fboundp 'org-remember) 'org-remember)
                     ((fboundp 'org-capture) 'org-capture)
                     (t nil))))
    (if rememberFn
        (define-key global-map "\C-cr" rememberFn)))

  (setq org-default-notes-file (concat org-directory "notes.org"))



  (setq org-remember-templates
        `(("Todo-W" ?t "*** TODO %?\n    %t" ,(concat org-directory "work.org") "Tasks")
          ("Todo-H" ?T "*** TODO %?\n    %t" ,(concat org-directory "home.org") "Tasks")))

  (setq org-agenda-custom-commands
        ' (("h" "Home TODOs" tags-todo "Home" ((org-agenda-sorting-strategy '(user-defined-up))))
           ("w" "Work TODOs" tags-todo "Work"  ((org-agenda-sorting-strategy '(user-defined-up)))))))
