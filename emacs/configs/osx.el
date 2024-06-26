(require 'dired)
(require 'ediff)

(setq mac-command-modifier 'control)
(setq mac-option-modifier 'alt)
(setq mac-control-modifier 'meta)
(setq mac-pass-command-to-system nil)

(when (fboundp #'mac-auto-operator-composition-mode)
  (mac-auto-operator-composition-mode))

(use-package ultra-scroll-mac
  :if (eq window-system 'mac)
  :straight (:type git :host github :repo "jdtsmith/ultra-scroll-mac")
  :init
  (setq scroll-conservatively 101 ; important!
        scroll-margin 0)
  :config
  (pixel-scroll-precision-mode -1)
  (ultra-scroll-mac-mode 1))


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

(defun my:dired-open-in-finder (files &optional arg)
  (interactive (let (( files (dired-get-marked-files t current-prefix-arg nil nil t)))
                 (list files current-prefix-arg)))
  (dired-do-shell-command "open -R" arg files))

(bind-key "F" #'my:dired-open-in-finder dired-mode-map)
