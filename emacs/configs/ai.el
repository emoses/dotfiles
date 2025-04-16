(use-package shell-maker
  :straight (:host github :repo "xenodium/shell-maker"))

(use-package copilot-chat
  :custom (copilot-chat-commit-prompt "Here is the result of running `git diff --cached`. Please suggest a one-line commit message. Don't add anything else to the response.
Do not use any markers around the commit message.



Here is the result of `git diff --cached`:
")
  :bind (("C-c C-i C-i" . copilot-chat-switch-to-buffer)
         ("C-c C-i RET" . copilot-chat-transient)
         ("A-i" . copilot-chat-transient)
         ("C-c C-i b". copilot-chat-add-current-buffer)
         ("C-c C-i l" . copilot-chat-list)
         ("C-c C-i f" . copilot-chat-custom-prompt-function)
         :map git-commit-mode-map
              ("C-c C-p" . copilot-chat-insert-commit-message))
  :straight (:host github :repo "chep/copilot-chat.el" :files ("*.el"))
  :after (request org markdown-mode shell-maker))

(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :custom (copilot-indent-offset-warning-disable t)
  :ensure t)
