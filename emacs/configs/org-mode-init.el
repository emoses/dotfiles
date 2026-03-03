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

(defvar org-babel-safe-languages '("plantuml"))

(use-package org
  :straight (:type built-in)
  :after (hydra)
  :mode ("\\.org$" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c o" . org-capture)
         :map org-mode-map
         ("C-c i" . org-toggle-item)
         ("C-c h" . org-toggle-heading)
         ("C-c r" . org-reveal)
         ("M-q" . org-fill-paragraph)
         ("A-h" . org-promote-subtree)
         ("A-j" . org-move-subtree-up)
         ("A-h" . org-move-subtree-down)
         ("A-h" . org-demote-subtree))
  :custom
  (org-export-with-toc nil)
  (org-export-date-timestamp-format "%Y-%m-%d")
  (org-startup-folded 'overview)
  (org-adapt-indentation t)
  :init
  (add-hook 'org-mode-hook 'flyspell-mode)
  :config
  (when (eq system-type 'windows-nt)
    (setq org-mobile-checksum-binary "d:/program files/gnu/sha1sum.exe"))
  ;(require 'org-install)
  ;;normally bound to org-reveal, but that's moved to C-c r above
  (define-key org-mode-map (kbd "C-c C-r") nil)

  ;Local windows
  ;(setq org-mobile-directory "~/ownCloud/MobileOrg")
  ;(setq org-directory "~/ownCloud/org")
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
              (add-to-list 'org-babel-load-languages '(shell . t))
              (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
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

  (setq org-default-notes-file (expand-file-name "notes.org" org-directory))
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images)

  ;;Add the "Insert" submenu
  (defvar org-org-menu-insert-menu
    (easy-menu-create-menu
     "Insert"
     '(["Insert structure template" org-insert-structure-template t]))
    "Org submenu for inserting stuff")
  (easy-menu-add-item org-org-menu nil org-org-menu-insert-menu "Archive")

  ;;Don't confirm on plantuml eval
  (defun my:org-confirm-babel-evaluate (lang body)
    (not (member lang org-babel-safe-languages)))
  (setq org-confirm-babel-evaluate #'my:org-confirm-babel-evaluate)

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

  ;; from https://emacs.stackexchange.com/questions/16688/how-can-i-escape-the-in-org-mode-to-prevent-bold-fontification/16746#16746
  (defun modi/org-entity-get-name (char)
    "Return the entity name for CHAR. For example, return \"ast\" for *."
    (let ((ll (append org-entities-user
                      org-entities))
          e name utf8)
      (catch 'break
        (while ll
          (setq e (pop ll))
          (when (not (stringp e))
            (setq utf8 (nth 6 e))
            (when (string= char utf8)
              (setq name (car e))
              (throw 'break name)))))))

  (defun modi/org-insert-org-entity-maybe (&rest args)
    "When the universal prefix C-u is used before entering any character,
    insert the character's `org-entity' name if available.

    If C-u prefix is not used and if `org-entity' name is not available, the
    returned value `entity-name' will be nil."
    ;; It would be fine to use just (this-command-keys) instead of
    ;; (substring (this-command-keys) -1) below in emacs 25+.
    ;; But if the user pressed "C-u *", then
    ;;  - in emacs 24.5, (this-command-keys) would return "^U*", and
    ;;  - in emacs 25.x, (this-command-keys) would return "*".
    ;; But in both versions, (substring (this-command-keys) -1) will return
    ;; "*", which is what we want.
    ;; http://thread.gmane.org/gmane.emacs.orgmode/106974/focus=106996
    (let ((pressed-key (substring (this-command-keys) -1))
          entity-name)
      (when (and (listp args) (eq 4 (car args)))
        (setq entity-name (modi/org-entity-get-name pressed-key))
        (when entity-name
          (setq entity-name (concat "\\" entity-name "{}"))
          (insert entity-name)
          (message (concat "Inserted `org-entity' "
                           (propertize entity-name
                                       'face 'font-lock-function-name-face)
                           " for the symbol "
                           (propertize pressed-key
                                       'face 'font-lock-function-name-face)
                           "."))))
      entity-name))

  ;; Run `org-self-insert-command' only if `modi/org-insert-org-entity-maybe'
  ;; returns nil.
  (advice-add 'org-self-insert-command :before-until #'modi/org-insert-org-entity-maybe) )

(use-package htmlize)

(use-package ox-gfm)

(use-package ox-slack
  :after org
  :straight (:type git :host github :repo "titaniumbones/ox-slack"))

(use-package ob-restclient
  :after org
  :config
  (add-to-list 'org-babel-load-languages '(restclient . t)))

(use-package ox-reveal
  :ensure org-reveal
  :config
  (setq org-reveal-root (concat "file://" (getenv "HOME") "/dev/reveal.js"))
  (add-to-list 'org-structure-template-alist '("n" . "notes") t))
