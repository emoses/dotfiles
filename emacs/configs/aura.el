(defun containing-dir (path)
  (file-name-nondirectory
   (directory-file-name (file-name-directory path))))

(defun aura-switch-file (ext)
  (find-file (concat (containing-dir (buffer-file-name)) ext)))

(defvar file-ext-alist '(
		   ("helper" . "Helper.js")
		   ("app" . ".app")
		   ("cmp" . ".cmp")
		   ("controller" . "Controller.js")
		   ("css" . ".css")
		   ("renderer" . "Renderer.js")))
		   
		   

(defun aura-switch-to-ext (ext-name)
  "Using the file-ext-alist map above, switch to one of the file extentions
   in the list"
  (interactive
   (list (completing-read "[Aura] Switch to: "
		    file-ext-alist
		    nil
		    t
		    nil
		    t
		    nil
		    nil)))
     (aura-switch-file (cdr (assoc ext-name file-ext-alist))))
     

     
		  
