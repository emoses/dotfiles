(setq mac-command-modifier 'control)
(setq mac-option-modifier 'alt)
(setq mac-control-modifier 'meta)


(defun my:frame-fullscreen-p ()
  "Is the current frame fullscreen?.  See toggle-frame-fullscreen in frames.el"
  (memq (frame-parameter nil 'fullscreen) '(fullscreen fullboth)))

;;If the emacs window is in fullscreen on osx, the ediff control frame will
;;show up on another desktop.  This will fix that by opening it in the same
;;frame if we're currently maximized 
(setq ediff-window-setup-function
      (lambda (&rest args)
          (if (my:frame-fullscreen-p)
              (apply #'ediff-setup-windows-plain args)
            (apply #'ediff-setup-windows-default args))))
                                       
