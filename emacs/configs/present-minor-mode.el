(provide 'present-minor-mode)

(defgroup present nil
  "Minor global mode for presentations"
  :group 'tools)

(defcustom present-text-scale-amount 3
  "The scale amount to set all the buffers to"
  :group 'present
  :type 'integer)

(defun update-all-buffers (&optional amt)
  (let ((scale-amount (or amt present-text-scale-amount)))
    (dolist (buff (buffer-list))
      (with-current-buffer buff
        (text-scale-set scale-amount)))))


(define-minor-mode present-minor-mode
  "A minor mode that zooms in all new buffers for presentations"
  :lighter " ZOOM"
  :global t
  (cond
   (present-minor-mode
    (add-hook 'buffer-list-update-hook #'update-all-buffers))
   (t
    (remove-hook 'buffer-list-update-hook #'update-all-buffers)
    (update-all-buffers 0))))
