;;Magit
(use-package magit
  :after (evil)
  :bind (("C-x M-g" . magit-file-dispatch)
         ("C-x M-S-g" . magit-dispatch-popup)
         :map magit-blame-mode-map
         ("C-c RET" . magit-show-commit)
         ("C-c c" . magit-blame-cycle-style))
  :custom-face
  (magit-diff-file-heading ((t (:background "selectedTextBackgroundColor" :foreground "selectedTextColor"))))
  (magit-diff-file-heading-highlight ((t (:background "selectedContentBackgroundColor" :foreground "selectedTextColor" :weight bold))))
  :config
  (when (and my:osx (not with-editor-emacsclient-executable))
    (setq with-editor-emacsclient-executable (expand-file-name "~/bin/emacsclient")))
  (setq magit-branch-read-upstream-first nil)
  (advice-add 'magit-push-popup :around #'magit-push-arguments-maybe-upstream)
  (setq magit-bury-buffer-function #'magit-mode-quit-window)
  (setq magit-process-finish-apply-ansi-colors t)


  (defun my:magit-rebase-onto-remote-default (args)
    "Rebase the current branch onto the default branch of the selected remote.
The remote is determined by `magit-get-some-remote`.
ARGS are the arguments passed to `git rebase`."
    (interactive (list (magit-rebase-arguments)))
    (if-let ((remote (magit-get-some-remote)))
        ;; magit--get-default-branch is an internal function to magit but does exactly what we want
        (if-let ((default-branch (magit--get-default-branch)))
            ;; default-branch will look like ("origin" . "main"), so join it with a "/"
            (let ((rebase-target (mapconcat #'identity default-branch "/")))
              (magit-git-rebase rebase-target args))
          (user-error "Unable to find default remote branch for remote %s" remote))
      (user-error "No remote found to rebase onto.")))

  (defun my:magit-ff-master-from-origin ()
    "Fetch origin, fast-forward local master to origin/master, and checkout master."
    (interactive)
    (let* ((remote (magit--get-default-branch))
          (remote-branch (format "%s/%s" (car remote) (cadr remote)))
          (local-branch (cadr remote)))
      (message "Fetching from %s..." remote-branch)
      (magit-git-fetch (car remote) nil)

      ;; This command attempts to update the local master ref to the origin/master ref.
      ;; The ":" prefix in the refspec implies it must be a fast-forward.
      (condition-case nil
          (progn
            (magit-call-git "switch" "-C" local-branch remote-branch)
            (message "Master fast-forwarded and checked out."))
        (error (message "Could not fast-forward master (is it ahead of origin?)")))))

;; Bind it to a key in Magit
  (transient-define-prefix my:magit-reflog ()
    "Display the reflog"
    [["Reflog"
      ("h" "Head" magit-reflog-head)
      ("o" "Other" magit-reflog-other)
      ("c" "Current" magit-reflog-current)]])
  (define-key magit-mode-map "#" #'my:magit-reflog)

  (transient-insert-suffix 'magit-rebase #'magit-rebase-branch
    '("o"
      (lambda ()
        (--when-let (magit-get-some-remote) (concat it "/master\n")))
      my:magit-rebase-onto-remote-default))
  (transient-insert-suffix 'magit-dispatch #'magit-run
    '("#" "Reflog" my:magit-reflog))
  (transient-append-suffix 'magit-pull #'magit-pull-branch
    '("M" "Pull master and checkout" my:magit-ff-master-from-origin))

  ;; Worktrees
  (defun my:magit-kill-worktree-buffers-advice (path &rest _args)
    "Kill all buffers visiting files within the deleted worktree PATH."
    (let ((expanded-path (expand-file-name path)))
      (dolist (buf (buffer-list))
        (let ((buf-file (buffer-file-name buf)))
          (when (and buf-file (string-prefix-p expanded-path (expand-file-name buf-file)))
            (kill-buffer buf))))))


  (advice-add 'magit-worktree-delete :after #'my:magit-kill-worktree-buffers-advice)

  (defun my:magit-copy-dir-locals-to-worktree (path &rest _)
    "Copy .dir-locals.el from the current project root to the new worktree PATH."
    (let ((source (expand-file-name ".dir-locals.el" (magit-toplevel)))
          (destination (expand-file-name ".dir-locals.el" path)))
      (when (file-exists-p source)
        (copy-file source destination t)
        (message "Copied .dir-locals.el to %s" path))))

  (add-hook 'magit-worktree-create-hook #'my:magit-copy-dir-locals-to-worktree)

  (evil-ex-define-cmd "bl[ame]" #'magit-blame-addition)
  (evil-ex-define-cmd "history" #'magit-log-buffer-file))

;; Don't enable by default
(use-package magit-delta
  :after magit
  :config
  (setq magit-delta-delta-args (append magit-delta-delta-args '("--features" "magit-delta"))))

(use-package forge
  :after magit
  :init
  (defun my:forge-browse-after-create-pr (value headers status req)
    (if-let ((url (assoc 'html_url value)))
        (browse-url (cdr url))))
  (add-hook 'forge-post-submit-callback-hook #'my:forge-browse-after-create-pr))
