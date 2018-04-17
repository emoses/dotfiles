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
