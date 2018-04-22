;;Expecting lines with key=val
(defconst my:secrets-file-path (locate-user-emacs-file "github-secrets" ".github-secrets"))

(defun -load-secrets-file (path)
  (with-temp-buffer
    (insert-file-contents path)
    (let ((secrets '(())))
      (while (re-search-forward "^\\(.*?\\)=\\(.*\\)$" nil t)
        (push (cons (match-string 1) (match-string 2)) secrets))
      secrets)))

(defvar secrets-alist (if (file-exists-p my:secrets-file-path)
                          (-load-secrets-file my:secrets-file-path)
                        '()))
