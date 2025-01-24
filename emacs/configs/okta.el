;; -*- lexical-binding: t -*-
(when (boundp 'okta)
  (require 'gotest)

  (defvar -okta-integration-test-history nil)
  (defun okta-integration-test (command)
    (interactive
     (list
      (read-string "Command: "
                   (elt -okta-integration-test-history 0)
                   '(-okta-integration-test-history . 1)
                   "SFT_DB_AUTOCLEAN=true SFT_DB_INTEGRATION_TESTS=true go test -failfast -v ")))
    (save-some-buffers (not compilation-ask-about-save))
    (compile command))

  (defun -okta-integration-test (args &optional unit-only)
    (save-some-buffers (not compilation-ask-about-save))
    (let ((env (format  "SFT_DB_AUTOCLEAN=true SFT_DB_INTEGRATION_TESTS=%s" (if unit-only "false" "true"))))
      (go-test--go-test args env)))

  (defun okta-integration-test-current-file ()
    (interactive)
    (let ((data (go-test--get-current-file-testing-data)))
      (-okta-integration-test (s-concat "-run='" data "' . -failfast -v"))))

  (defun okta-integration-test-current-test (arg &optional last)
    "Launch go test on the current test. Largely copy/paste from go-test-current-test."
    (interactive "P")
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
              (-okta-integration-test (s-concat test-flag test-name "\\$ . -v " additional-arguments) arg)))))))

  (with-eval-after-load 'go-mode
    (define-key go-mode-map (kbd "C-c t") #'okta-integration-test-current-test)
    (define-key go-mode-map (kbd "C-c C-t") #'okta-integration-test-current-file))

  (with-eval-after-load 'go-ts-mode
    (define-key go-ts-mode-map (kbd "C-c t") #'okta-integration-test-current-test)
    (define-key go-ts-mode-map (kbd "C-c C-t") #'okta-integration-test-current-file))

  (defun dlv-integration-test (&optional cmd)
    (interactive)
    (progn
      (setenv "SFT_DB_AUTOCLEAN" "true")
      (setenv "SFT_DB_INTEGRATION_TESTS" "true")
      (if (called-interactively-p)
          (call-interactively 'dlv)
        (dlv cmd))))

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
          (goto-char (point-min))
          (condition-case nil
              (let ((json (json-parse-string line)))
                (insert (format "Error: %s\n\n" (gethash "recovered_error" json "Unknown")))
                (insert (gethash "stack" json)))
            (json-parse-error (progn
                                ;;fall back to naive parse
                                (insert line)
                                (delete-region (point) (search-forward "\"stack\":\""))
                                (delete-region (search-forward-regexp "[^\\]\"") (point-max)))))
          (unescape-nt)))))

  (defun okta:get-test-postgres-container-id ()
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (if (search-forward "\"container_name\": \"landlord_sft_postgres_platform_ee2807f9_1a16_4636\"")
        (progn
          (when (search-forward-regexp "\"container_id\": \"\\([^\"]+\\)\"")
            (kill-new (match-string 1))))
        (error "No container id found"))))

  (require 'auth-source)
  (require 'ghub)
  (defun auth-source-backend-git-credential-helper (entry)
    (when (and (stringp entry) (string-match "^git-credential-helper" entry))
      (auth-source-backend
       :source  "git-credential-helper"
       :type 'git-credential
       :search-function #'auth-source-git-credential-helper-search)))


  (defun auth-source-git-credential-helper--append (result key &optional filter)
    "Append the value between match-end and the end of the line to
plist RESULT with KEY.  If FILTER is present, call it with the
match data and any existing result at that key, and put its value
at KEY."
    (let* ((data (buffer-substring-no-properties (match-end 0) (line-end-position)))
           (data (if (functionp filter) (funcall filter data (plist-get result key)) data)))
      (plist-put result key data)))

  (defun auth-source-git-credential-helper--process-output ()
    (let ((ret '()))
      (goto-char (point-min))
      (while (not (eobp))
        (cond
         ((looking-at "^password=")
          (setq ret (auth-source-git-credential-helper--append ret :secret (lambda (data &rest _)
                                                                             (let ((v (auth-source--obfuscate data)))
                                                                               (lambda () (auth-source--deobfuscate v)))))))
         ((looking-at "^username=")
          (setq ret (auth-source-git-credential-helper--append ret :user)))
         ((looking-at "^host=")
          (setq ret (auth-source-git-credential-helper--append ret :host (lambda (data &optional existing) (concat existing data)))))
         ((looking-at "^protocol=")
          (setq ret (auth-source-git-credential-helper--append ret :host (lambda (data &optional existing) (concat data "://" existing))))))
        (forward-line))
      ret))

  (defvar auth-source-git-credential-helper-org "atko-pam")

  (cl-defun auth-source-git-credential-helper-search (&rest spec
                                                            &key create delete type
                                                            &allow-other-keys)
    (cl-assert (not create) nil "git-credential-helper doesn't support create")
    (cl-assert (not delete) nil "git-credential-helper doesn't support delete")

    (when (string-equal (plist-get spec :host) "api.github.com")
      (let ((user (car (string-split (plist-get spec :user) "\\^")))
            (helper (ignore-errors (car (process-lines "git" "config" "credential.helper")))))
        (when (and user helper)
          (let ((helper-and-args (append (string-split helper " ") (list "get")))
                (out-buf (generate-new-buffer "output")))
            (unwind-protect
                (progn
                  (apply #'call-process-region
                         (format "username=%s\nprotocol=https\nhost=github.com\npath=%s\n" user auth-source-git-credential-helper-org)
                         nil (car helper-and-args) nil out-buf nil (cdr helper-and-args))
                  (with-current-buffer out-buf
                    (let ((processed (auth-source-git-credential-helper--process-output)))
                      (and (plist-get processed :secret) (list (plist-put processed :type type))))))
              (kill-buffer out-buf)))))))



  (add-hook 'auth-source-backend-parser-functions #'auth-source-backend-git-credential-helper)
  (add-to-list 'auth-sources "git-credential-helper")

  (with-eval-after-load 'dap-mode
    (dap-register-debug-template "Go Dlv Test Integration Current Function "
                                 (list :type "go"
                                       :request "launch"
                                       :name "Test function"
                                       :mode "test"
                                       :program nil
                                       :args nil
                                       :env '(("SFT_DB_AUTOCLEAN" . "true")
                                              ("SFT_DB_INTEGRATION_TESTS" . "true"))))

    (dap-register-debug-template "Go Dlv Test Integration Current Subtest "
                                 (list :type "go"
                                       :request "launch"
                                       :name "Test subtest"
                                       :mode "test"
                                       :program nil
                                       :args nil
                                       :env '(("SFT_DB_AUTOCLEAN" . "true")
                                              ("SFT_DB_INTEGRATION_TESTS" . "true")))))

  (with-eval-after-load 'sql-mode
    (add-to-list sql-product-alist
		 (tilt
		  :name "Postgres-tilt"
		  :free-software t
		  :font-lock sql-mode-postgres-font-lock-keywords
		  :sqli-program "kubectl"
		  :sqli-options sql-postgres-options
		  :sqli-login sql-postgres-login-params
		  :sqli-comint-func sql-comint-postgres
		  :list-all ("\\d+" . "\\dS+")
		  :list-table ("\\d+ %s" . "\\dS+ %s")
		  :completion-object sql-postgres-completion-object
		  :prompt-regexp "^[-[:alnum:]_]*[-=][#>] "
		  :prompt-length 5
		  :prompt-cont-regexp "^[-[:alnum:]_]*[-'(][#>] "
		  :statement sql-postgres-statement-starters
		  :input-filter sql-remove-tabs-filter
		  :terminator ("\\(^\\s-*\\\\g\\|;\\)" . "\\g")))
    (defun tilt-db ()
      (interactive)
      (let* ((pod-name (string-trim (shell-command-to-string
                                     "kubectl get pod -n data -l \"app.kubernetes.io/instance=asa-postgresql\" -o name")))
             (sql-postgres-options (list "exec" "-n" "data" "-it" pod-name "-c" "asa-postgresql" "--" "psql" "user=postgres sslmode=disable host=127.0.0.1 password=postgres dbname=scaleft"))
             (sql-postgres-program "kubectl")
             (sql-postgres-login-params '())
             (sql-server "")
             (sql-user "")
             (sql-database "")
             (sql-port 0))
	(call-interactively #'sql-postgres))))
    )
