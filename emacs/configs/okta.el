(defun okta-integration-test ()
  (interactive)
  (let ((compile-command "GO111MODULE=on SFT_DB_AUTOCLEAN=true SFT_DB_INTEGRATION_TESTS=true go test -failfast -v "))
    (call-interactively 'compile)))

(defun dlv-integration-test ()
  (interactive)
  (progn
    (setenv "SFT_DB_AUTOCLEAN" "true")
    (setenv "SFT_DB_INTEGRATION_TESTS" "true")
    (call-interactively 'dlv)))
