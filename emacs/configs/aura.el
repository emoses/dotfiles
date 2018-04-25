;;Functions for editing Salesforce Lightning.  Hopefully never need these again
(defun containing-dir (path)
  (file-name-nondirectory
   (directory-file-name (file-name-directory path))))

(defun aura:switch-file (ext &optional cmd)
  (let ((file-cmd (if cmd cmd 'find-file)))
    (funcall file-cmd (concat (containing-dir (buffer-file-name)) ext))))

(setq auto-mode-alist
      (append (list (cons "\\.\\(cmp\\|app\\|evt\\|theme\\)\\'" my:xml-mode)) ;;Lumen
	      auto-mode-alist
	      ))

(defvar file-ext-alist '(
		   ("cmp" . ".cmp")
		   ("controller" . "Controller.js")
		   ("helper" . "Helper.js")
		   ("app" . ".app")
		   ("css" . ".css")
		   ("renderer" . "Renderer.js")
		   ("theme" . ".theme")
		   ("test" . "Test.js")))
(defvar aura:switch-history '())
(put 'aura:switch-history 'history-length 5)



(defun aura-switch-to-ext (ext-name)
  "Using the file-ext-alist map above, switch to one of the file extentions
   in the list"
  (interactive
   (list (completing-read "[Aura] Switch to: "
		    file-ext-alist
		    nil
		    t
		    nil
		    'aura:switch-history
		    nil
		    nil)))
  (aura:switch-file (cdr (assoc ext-name file-ext-alist)) 'find-file))

(defun aura-switch-to-ext-other-window (ext-name)
  "See aura-switch-to-ext, same but open in other window"
  (interactive
   (list (completing-read "[Aura] Switch to: "
		    file-ext-alist
		    nil
		    t
		    nil
		    'aura:switch-history
		    nil
		    nil)))
  (aura:switch-file (cdr (assoc ext-name file-ext-alist)) 'find-file-other-window))

(global-set-key (kbd "C-c C-a") 'aura-switch-to-ext)
(global-set-key (kbd "C-c 4 a") 'aura-switch-to-ext-other-window)
