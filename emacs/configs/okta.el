(when (boundp 'okta)
  (require 'gotest)

  (defvar -okta-integration-test-history nil)
  (defun okta-integration-test (command)
    (interactive
     (list
      (read-string "Command: "
                   (elt -okta-integration-test-history 0)
                   '(-okta-integration-test-history . 1)
                   "GO111MODULE=on SFT_DB_AUTOCLEAN=true SFT_DB_INTEGRATION_TESTS=true go test -failfast -v ")))
    (save-some-buffers (not compilation-ask-about-save))
    (compile command))

  (defun -okta-integration-test (args)
    (save-some-buffers (not compilation-ask-about-save))
    (go-test--go-test args "GO111MODULE=on SFT_DB_AUTOCLEAN=true SFT_DB_INTEGRATION_TESTS=true"))

  (defun okta-integration-test-current-file ()
    (interactive)
    (let ((data (go-test--get-current-file-testing-data)))
      (-okta-integration-test (s-concat "-run='" data "' . -failfast -v"))))

  (defun okta-integration-test-current-test (arg &optional last)
    "Launch go test on the current test. Largely copy/paste from go-test-current-test."
    (interactive "P")
    (if arg
        (call-interactively #'go-test-current-test last)
      (progn
        (unless (string-equal (symbol-name last) "last")
          (setq go-test--current-test-cache (go-test--get-current-test-info)))
        (when go-test--current-test-cache
          (cl-destructuring-bind (test-suite test-name) go-test--current-test-cache
            (let ((test-flag (if (> (length test-suite) 0) "-m " "-run "))
                  (additional-arguments (if go-test-additional-arguments-function
                                            (funcall go-test-additional-arguments-function
                                                     test-suite test-name) "")))
              (when test-name
                (-okta-integration-test (s-concat test-flag test-name "\\$ . -v " additional-arguments)))))))))

  (with-eval-after-load "go-mode"
    (define-key go-mode-map (kbd "C-c t") #'okta-integration-test-current-test)
    (define-key go-mode-map (kbd "C-c C-t") #'okta-integration-test-current-file))

  (defun dlv-integration-test ()
    (interactive)
    (progn
      (setenv "SFT_DB_AUTOCLEAN" "true")
      (setenv "SFT_DB_INTEGRATION_TESTS" "true")
      (call-interactively 'dlv)))

  (defun dlv-integration-test-current-func ()
    (interactive)
    (progn
      (setenv "SFT_DB_AUTOCLEAN" "true")
      (setenv "SFT_DB_INTEGRATION_TESTS" "true")
      (call-interactively 'dlv-current-func)))

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

  (defun my:fix-log-file-on-open ()
    (when (string-match-p ".log\\'" (buffer-file-name))
      (save-excursion
        (goto-char (point-min))
        (when (search-forward "" (+ (point-min) 5000) t)
          (message "Fixing up newlines")
          (fix-newlines)))))

  (add-hook 'find-file-hook #'my:fix-log-file-on-open)


  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  (defmacro dev:with-tramp-host (host &rest body)
    (declare (indent 1) (debug let))
    `(let ((default-directory ,(concat "/ssh:" host ":")))
       ,@body))

  (defun okta:extract-log-panic ()
    (interactive)
    (let ((line (thing-at-point 'line t))
          (bufname "*okta log panic*"))
      (with-help-window bufname
        (with-current-buffer bufname
          (insert line)
          (goto-char (point-min))
          (delete-region (point) (search-forward "\"stack\":\""))
          (delete-region (search-forward-regexp "[^\\]\"") (point-max))
          (unescape-nt))))))
