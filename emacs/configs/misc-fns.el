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

;; (defun transpose-windows ()
;;    "Transpose the buffers shown in two windows."
;;    (let (nWin (count-windows))
;;      (do-transpose (lambda (win1 win2)
;; 		     (let win2buff (window-buffer win2))
;; 		     (set-window-buffer win2 (window-buffer win1))
;; 		     (set-window-buffer win1 (win2buff)))))
;;      (if (= nWin 2 ) (do-transpose (selected-window) (next-window)) nil))

