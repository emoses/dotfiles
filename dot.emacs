;;; -*- mode: emacs-lisp -*-
;;; Evan Moses .emacs
;;; Feel free to copy

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-dabbrev-downcase nil)
 '(company-dabbrev-ignore-case nil)
 '(connection-local-criteria-alist
   '(((:application tramp :machine "Computery.local")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp :machine "FK00M29L63")
      tramp-connection-local-darwin-ps-profile)
     ((:application eshell)
      eshell-connection-default-profile)
     ((:application tramp :machine "localhost")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp :machine "C02DR5M6MD6T")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)))
 '(connection-local-profile-alist
   '((tramp-kubernetes-connection-local-default-profile (tramp-config-check . tramp-kubernetes--current-context-data)
                                                        (tramp-extra-expand-args 97
                                                                                 (tramp-kubernetes--container
                                                                                  (car tramp-current-connection))
                                                                                 104
                                                                                 (tramp-kubernetes--pod
                                                                                  (car tramp-current-connection))
                                                                                 120
                                                                                 (tramp-kubernetes--context-namespace
                                                                                  (car tramp-current-connection))))
     (eshell-connection-default-profile (eshell-path-env-list))
     (tramp-connection-local-darwin-ps-profile
     (tramp-process-attributes-ps-args "-acxww" "-o"
                                        "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                        "-o" "state=abcde" "-o"
                                        "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format (pid . number) (euid . number) (user . string) (egid . number) (comm . 52)
                                          (state . 5) (ppid . number) (pgrp . number) (sess . number) (ttname . string)
                                          (tpgid . number) (minflt . number) (majflt . number) (time . tramp-ps-time)
                                          (pri . number) (nice . number) (vsize . number) (rss . number)
                                          (etime . tramp-ps-time) (pcpu . number) (pmem . number) (args)))
     (tramp-connection-local-busybox-ps-profile

