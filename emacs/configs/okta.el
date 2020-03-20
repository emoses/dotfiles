(defvar -okta-integration-test-history nil)
(defun okta-integration-test (command)
  (interactive
   (list
    (read-string "Command: "
                 (elt -okta-integration-test-history 0)
                 '(-okta-integration-test-history . 1)
                 "GO111MODULE=on SFT_DB_AUTOCLEAN=true SFT_DB_INTEGRATION_TESTS=true go test -failfast -v ")))
  (compile command))
(eval-after-load "go-mode"
  (bind-key (kbd "C-c t") #'okta-integration-test go-mode-map))

(defun dlv-integration-test ()
  (interactive)
  (progn
    (setenv "SFT_DB_AUTOCLEAN" "true")
    (setenv "SFT_DB_INTEGRATION_TESTS" "true")
    (call-interactively 'dlv)))

(defun transform-route ()
  (when-let ((pt (re-search-forward "<Route.*?/>" nil t)))
    (let ((start (match-beginning 0))
          (end (match-end 0))
          (result "{\n"))
      (goto-char start)
      (while (re-search-forward "\\([[:alpha:]]*\\)=\\([\"{]\\)\\([^\"}]*\\)\\([\"}]\\)" end t)
        (let ((name (match-string-no-properties 1)))
          (setq result (s-concat result "  " name ": "))
          (let ((opening (match-string-no-properties 2))
                (val (match-string-no-properties 3))
                (closing (match-string-no-properties 4)))
            (cond
             ((s-equals? name "name") (setq result (s-concat result "Routes." (camel-case val) ",\n")))
             ((s-equals? opening "\"") (setq result (s-concat result opening val closing ",\n")))
             (t (setq result (s-concat result val ",\n")))))))
      (setq result (s-concat result "}"))
      result)))
