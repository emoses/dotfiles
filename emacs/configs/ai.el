(use-package copilot-chat
  :custom (copilot-chat-commit-prompt "Here is the result of running `git diff --cached`. Please suggest a one-line commit message. Don't add anything else to the response.
Do not use any markers around the commit message.



Here is the result of `git diff --cached`:
")
  :bind (:map git-commit-mode-map
              ("C-c C-p" . copilot-chat-insert-commit-message))
  :straight (:host github :repo "chep/copilot-chat.el" :files ("*.el"))
  :after (request org markdown-mode shell-maker))

(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :custom (copilot-indent-offset-warning-disable t)
  :ensure t)
