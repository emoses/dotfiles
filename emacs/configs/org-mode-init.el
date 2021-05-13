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
  :straight org-plus-contrib
  :after (hydra)
  :mode ("\\.org$" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c o" . org-capture)
         :map org-mode-map
         ("C-c i" . org-toggle-item)
         ("C-c h" . org-toggle-heading)
         ("C-c r" . org-reveal)
         ("M-q" . org-fill-paragraph))
  :custom
  (org-export-with-toc nil)
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
  (when my:windows
    (setq org-mobile-checksum-binary "c:\\Program Files (x86)\\GnuWin32\\bin\\md5sum.exe"))
  (add-hook 'org-mode-hook
            (lambda ()
              (org-defkey org-mode-map (kbd "RET") 'org-return-indent)
              (org-defkey org-mode-map "\C-j" 'org-return)
              (display-line-numbers-mode -1)
              (auto-composition-mode -1)))
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
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images)

  ;;Add the "Insert" submenu
  (defvar org-org-menu-insert-menu
    (easy-menu-create-menu
     "Insert"
     '(["Insert structure template" org-insert-structure-template t]))
    "Org submenu for inserting stuff")
  (easy-menu-add-item org-org-menu nil org-org-menu-insert-menu "Archive")

  (defhydra my:org-item-hydra (:color pink
                                      :hint nil
                                      :timeout 2)
    "
  _h_: <-      _l_: ->    _-_: Toggle item
  ^ ^          ^ ^        _*_: Toggle heading
  _q_/_RET_: _q_uit   ^^  _t_: Cycle _t_odo
   "
    ("h" #'org-metaleft)
    ("l" #'org-metaright)
    ("-" #'org-toggle-item)
    ("*" #'org-toggle-heading)
    ("t" #'org-todo)
    ("q" nil)
    ("RET" nil))
  (bind-key (kbd "A-t") #'my:org-item-hydra/body org-mode-map)
  (require 'ox-confluence))

(use-package htmlize)

(use-package ox-slack
  :after org
  :straight (:type git :host github :repo "titaniumbones/ox-slack"))
