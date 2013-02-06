;;;;;;;;
;   Select-cvs, a funciton to deal with multiple cvs repositories
; in environments where CVSROOT might not be correctly set for your
; current project.
;;;;;;;

;;Alist for select-cvs.  The key is a name for your cvs repository,
;; and the value is the appropriate value for CVSROOT for that repistory.
(defvar cvsroot-alist '(
			("engin" . "emoses@engin.swarthmore.edu:/home/galadriel/class04/emoses/cvs")
			("cs" . "/home/moses/cvsroot")
			("bmc" . "emoses@bubo.brynmawr.edu:/home/CVS")))

;;Make sure CVS_RSH is set to ssh.  Change this if you use some
;; other method to connect
(if (not (getenv "CVS_RSH"))
    (setenv "CVS_RSH" "ssh"))

(defun select-cvs (server)
  (interactive
   (let ((out
	  ;;This will ask for the name of the cvs server you want, pulling the
          ;;names from cvsroot-alist, above.  It does completion.
	  (completing-read "Cvs server: "
			   cvsroot-alist
			   nil
			   t
			   nil
			   nil
			   (cdr (cdr cvsroot-alist))
			   nil)))
     (list out)))
  (setq cvs-cvsroot (cdr (assoc server cvsroot-alist))))
