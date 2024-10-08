;; -*- lexical-binding: t -*-

(require 'url-util)
(require 'subr-x)

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))

(defun switch-to-minibuffer ()
  "Switch to the minibuffer window"
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))

(defun find-file-other-from-eshell (filename &optional wildcards)
  "If we're in our own frame, open a file in another frame.  If
this is the only frame, open it in another window.  See
find-file-other-frame and display-buffer"
  (interactive
   (find-file-read-args "Find file in other frame or window: "
                        (confirm-nonexistent-file-or-buffer)))
  (let* ((this-frame (window-frame (get-buffer-window)))
         (use-other-frame (and (> (length (frame-list)) 1)
                               (= 1 (length (window-list this-frame))))))
    (if (not use-other-frame)
        (find-file-other-window filename wildcards)
      (let ((value (find-file-noselect filename nil nil wildcards)))
        (if (listp value)
	    (progn
	      (setq value (nreverse value))
	      (switch-to-buffer-other-frame (car value))
	      (mapc 'switch-to-buffer (cdr value))
	      value)
          (pop-to-buffer value '((display-buffer-use-some-frame)
                                 (reusable-frames . 0)
                                 (inhibit-same-window . t))))))))

(defun gh-change-profile (profile)
  "Change the profile used by gh.el"
  (interactive
   (list (completing-read "[gh] Switch profile to: "
                          gh-profile-alist
                          nil
                          t
                          nil
                          'gh:profile-history
                          nil
                          nil)))
  (setq gh-profile-current-profile profile))

;;From http://emacs.stackexchange.com/questions/13772/how-to-prevent-magit-to-ask-where-to-push-a-branch/13784#13784
(defun magit-push-arguments-maybe-upstream (magit-push-popup-fun &rest args)
  "Enable --set-upstream switch if there isn't a current upstream."
  (let ((magit-push-arguments
         (if (magit-get-remote) magit-push-arguments
           (cons "--set-upstream" magit-push-arguments))))
    (apply magit-push-popup-fun args)))

(defun sudo-edit-etc-hosts ()
  "shortcut to open /etc/hosts as root"
  (interactive)
  (find-file "/sudo::/etc/hosts"))

;; (defun transpose-windows ()
;;    "Transpose the buffers shown in two windows."
;;    (let (nWin (count-windows))
;;      (do-transpose (lambda (win1 win2)
;; 		     (let win2buff (window-buffer win2))
;; 		     (set-window-buffer win2 (window-buffer win1))
;; 		     (set-window-buffer win1 (win2buff)))))
;;      (if (= nWin 2 ) (do-transpose (selected-window) (next-window)) nil))

;; From http://emacswiki.org/emacs/CamelCase, with modifications
(defun split-name (s)
  (let ((case-fold-search nil))
    (split-string
     (downcase
      (replace-regexp-in-string "\\([a-z]\\)\\([A-Z]\\)" "\\1 \\2" s)) "[^A-Za-z0-9]+")))

(defun lower-camel-case  (s)
  "lowerCamelCase"
  (let ((split (split-name s)))
    (concat (downcase (car split))
            (mapconcat 'capitalize (cdr split) ""))))
(defun camel-case (s)
  "CamelCase"
  (mapconcat 'capitalize (split-name s) ""))
(defun snake-case (s)
  "underscore_case"
  (mapconcat 'downcase   (split-name s) "_"))
(defun kebab-case (s)
  "kebab-case"
  (mapconcat 'downcase   (split-name s) "-"))

(defun caseify-word-at-point (caseifyer)
  (save-excursion
    (let* ((case-fold-search nil)
           (beg (if (use-region-p) (region-beginning) (and (skip-chars-backward "[:alnum:]:_-") (point))))
           (end (if (use-region-p) (region-end) (and (skip-chars-forward  "[:alnum:]:_-") (point))))
           (txt (buffer-substring-no-properties beg end))
           (cml (funcall caseifyer txt)))
      (if cml (progn (delete-region beg end) (insert cml))))))


(defun snake-case-region-or-word ()
  (interactive)
  (caseify-word-at-point #'snake-case))

(defun camel-case-region-or-word ()
  (interactive)
  (caseify-word-at-point #'camel-case))

(defun lower-camel-case-region-or-word ()
  (interactive)
  (caseify-word-at-point #'lower-camel-case))

(defun kebab-case-region-or-word ()
  (interactive)
  (caseify-word-at-point #'kebab-case))

(defun get-github-file-and-line-link (filename lineno)
  (interactive (list (buffer-file-name) (line-number-at-pos)))
  (if-let ((repo (magit-gh-pulls-guess-repo)))
      (let* ((path (file-relative-name filename (vc-root-dir)))
             (branch (if (or current-prefix-arg (bound-and-true-p evil-ex-argument))
                         (magit-get-current-branch)
                       "master"))
             (gh-url (format "https://github.com/%s/%s/tree/%s/%s#L%d"
                             (car repo)
                             (cdr repo)
                             branch
                             path
                             lineno)))
        (message "%s (copied to clipboard)" gh-url)
        (kill-new gh-url))
    (message "No github root detected")))

(defun get-current-buffer-filename ()
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        nil
      filename)))

(defun copy-current-buffer-filename (arg)
  "Copy the current buffer's filename into the kill ring.  If ARG is
provided, copy the whole path, otherwise just the basename"
  (interactive "P")
  (if-let (filename (get-current-buffer-filename))
      (progn
        (unless arg (setq filename (file-name-nondirectory filename)))
        (kill-new filename)
        (message "Copied: %s" filename))
    (message "This buffer has no file")))

(defun rename-this-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((filename (get-current-buffer-filename)))
    (if (not filename)
        (error "Buffer '%s' is not visiting a file!" (buffer-name))
      (let* ((dir (file-name-directory filename))
             (fname (file-name-nondirectory filename))
             (new-name (read-file-name "New name: " dir nil nil fname)))
        (cond ((get-buffer new-name)
               (error "A buffer named '%s' already exists!" new-name))
              (t
               (let ((dir (file-name-directory new-name)))
                 (when (and (not (file-exists-p dir)) (yes-or-no-p (format "Create directory '%s'?" dir)))
                   (make-directory dir t)))
               (rename-file filename new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil)
               (when (fboundp 'recentf-add-file)
                 (recentf-add-file new-name)
                 (recentf-remove-if-non-kept filename))
               (when (and (fboundp 'projectile-invalidate-cache))
                 (projectile-project-p)
                 (call-interactively #'projectile-invalidate-cache))
               (message "File '%s' successfully renamed to '%s'" filename (file-name-nondirectory new-name))))))))

(defun delete-this-file ()
  "Delete the file being visited by this buffer"
  (interactive)
  (let ((filename (get-current-buffer-filename)))
    (if (not filename)
        (error "Buffer %s is not visiting a file!", (buffer-name))
      (delete-file filename))))

(defun kill-ag-buffers ()
  "Kill all ag results buffers"
  (interactive)
  (let ((ag-buffers (-filter
                     (lambda (buf)
                       (s-matches? "\*ag search text:.*\*$" (buffer-name buf)))
                     (buffer-list))))
    (-each ag-buffers 'kill-buffer)))

(defun find-executable-in-node-modules (filename)
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (executable (and root
                          (expand-file-name (concat (file-name-as-directory "node_modules/.bin") filename)
                                            root))))
    (when (and executable (file-executable-p executable ))
      executable)))

(defun fix-newlines ()
  "Replace  in the middle of lines with a newline, and remove  at end of lines"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (while (search-forward "\n" nil t)
      (replace-match "\n")))
  (save-excursion
    (beginning-of-buffer)
    (while (re-search-forward "" nil t)
      (replace-match "\n" nil t))))

(defun unescape-nt ()
  "Replace \n with newline and \t with tab.  Operates on region if active, current line if not"
  (interactive)
  (let (beg end)
    (if mark-active
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (save-excursion
      (goto-char beg)
      (while (search-forward "\\n" end t)
        (replace-match "
"))
      (goto-char beg)
      (while (search-forward "\\t" end t)
        (replace-match "	")))))

(defun urldecode-region (start end)
  (interactive "r")
  (let ((text (delete-and-extract-region start end)))
    (insert (url-unhex-string text))))

(defun urlencode-region (start end)
  (interactive "r")
  (let ((text (delete-and-extract-region start end)))
    (insert (url-unhex-string text))))

(defun file-notify-rm-all-watches ()
  "Remove all existing file watches"
  (interactive)
  (maphash
   (lambda (k _v)
     (file-notify-rm-watch k))
   file-notify-descriptors))


(defun make-display-buffer-matcher-function (major-modes)
  (lambda (buffer-name _action)
    (with-current-buffer buffer-name (apply #'derived-mode-p major-modes))))

(defun insert-uuid ()
  "Insert a UUID. This commands calls “uuidgen” on MacOS, Linux,
and calls PowelShell on Microsoft Windows."
  (interactive)
  (let ((uuid (cond
                ((string-equal system-type "windows-nt")
                 (shell-command-to-string "pwsh.exe -Command [guid]::NewGuid().toString()"))
                ((string-equal system-type "darwin") ; Mac
                 (shell-command-to-string "uuidgen"))
                ((string-equal system-type "gnu/linux")
                 (shell-command-to-string "uuidgen")))))
    (insert (downcase (string-trim uuid)))))

(defun secret-from-auth-source (&rest search)
  "Use SEARCH, the arguments to auth-source-search, to find a
secret and return just the secret part.  Nil if not found"
  (when-let ((s (apply #'auth-source-search search))
             (secret (plist-get (car s) :secret)))
    (if (functionp secret)
        (funcall secret)
      secret)))

(require 'xref)
;;Copy of xref-goto-xref that works for mouse pointer
(defun my:xref-goto-xref-mouse (event &optional quit)
  (interactive "eP")
  (let* ((xref-buffer)
         (xref (save-excursion
                 (mouse-set-point event)
                 (setq xref-buffer (current-buffer))
                 (xref--set-arrow)
                 (xref--item-at-point))))
    (if (not xref)
      (user-error "Choose a reference to visit")
      (progn
        (xref--show-location (xref-item-location xref) (if quit 'quit t))
        (next-error-found xref-buffer (current-buffer))))))

(bind-key [mouse-2] #'my:xref-goto-xref-mouse xref--button-map)

(defun sql-pgify-placeholders (beg end)
  "Replace ? with $n, starting at $1, in the region, or the whole
buffer if the region is not active"
  (interactive "r")
  (unless (use-region-p)
    (setq beg (point-min) end (point-max)))
  (save-excursion
    (goto-char beg)
    (let ((n 1))
      (while (search-forward "?" end t)
        (if (and (/= (point) end) (char-equal (char-after) ??))
            (forward-char)
          (progn
            (delete-char -1)
            (insert (format "$%d" n))
            (setq n (+ n 1))))))))
