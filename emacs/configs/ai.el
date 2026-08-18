(use-package shell-maker
  :straight (:host github :repo "xenodium/shell-maker"))

;; (use-package copilot-chat
;;   :custom (copilot-chat-commit-prompt "Here is the result of running `git diff --cached`. Please suggest a one-line commit message. Don't add anything else to the response.
;; Do not use any markers around the commit message.



;; Here is the result of `git diff --cached`:
;; ")
;;   (copilot-chat-model claude-3.7-sonnet)
;;   :bind (("C-c C-i C-i" . copilot-chat-switch-to-buffer)
;;          ("C-c C-i RET" . copilot-chat-transient)
;;          ("A-i" . copilot-chat-transient)
;;          ("C-c C-i b". copilot-chat-add-current-buffer)
;;          ("C-c C-i l" . copilot-chat-list)
;;          ("C-c C-i f" . copilot-chat-custom-prompt-function)
;;          :map git-commit-mode-map
;;               ("C-c C-p" . copilot-chat-insert-commit-message))
;;   :straight (:host github :repo "chep/copilot-chat.el" :files ("*.el"))
;;   :after (request org markdown-mode shell-maker))

(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :bind (:map copilot-mode-map
              ("C-\"" . copilot-accept-completion))
  :custom (copilot-indent-offset-warning-disable t)
  :ensure t
  :config
  (add-to-list 'copilot-disable-predicates
               (lambda () (derived-mode-p 'agent-shell-mode))))

(use-package aider
  :straight (:host github :repo "tninja/aider.el" :files ("aider.el" "aider-core.el" "aider-file.el" "aider-code-change.el" "aider-discussion.el" "aider-prompt-mode.el"))
  :bind (("μ" . aider-transient-menu)
         )
  :config
  (setq aider-args '("--model" "bedrock/us.anthropic.claude-3-7-sonnet-20250219-v1:0") )
  ;; Or use your personal config file
  ;; (setq aider-args `("--config" ,(expand-file-name "~/.aider.conf.yml")))
  ;; ;;
)

(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el")
  :bind ( ("A-c" . claude-code-ide-menu)
          ("¢" . claude-code-ide-menu)) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools

(use-package agent-shell
  :bind (("A-i" . agent-shell-commands)
         :map agent-shell-mode-map
         ("C-RET" . comint-send-input))
  :ensure-system-package
  ;; Add agent installation configs here
  ((claude . "brew install claude-code")
   (claude-agent-acp . "npm install -g @agentclientprotocol/claude-agent-acp"))
  :config

  (evil-define-key 'insert agent-shell-mode-map (kbd "RET") #'newline)
  (evil-define-key 'insert agent-shell-mode-map (kbd "C-RET") #'comint-send-input)
  (evil-define-key 'normal agent-shell-mode-map (kbd "RET") #'comint-send-input)

  (defun my:diff-mode-agent-shell-hook ()
    (when (string-match-p "\\*agent-shell-diff\\*" (buffer-name))
      (evil-emacs-state)))
  (add-hook 'diff-mode-hook #'my:diff-mode-agent-shell-hook)

  (setq agent-shell-preferred-agent-config (agent-shell-anthropic-make-claude-code-config))

  (transient-define-prefix agent-shell-commands ()
    "Agent shell"
    [
     :class transient-columns
     [
      :class transient-column
      :description "Commands"
      ("s" "Start" agent-shell)
      ("n" "New" agent-shell-new-shell)
      ("b" "Toggle buffer" agent-shell-toggle)
      ("c" "Clear" agent-shell-clear-buffer)
      ]
     [
      :class transient-column
      :description "Insert"
      ("f" "File" agent-shell-insert-file)
      ("r" "Region" agent-shell-send-region)
      ("i" "Dwim" agent-shell-send-dwim)
      ]
     [
      :class transient-column
      :description "Sidebar"
      ("S" "Toggle" agent-shell-sidebar-toggle)
      ("O" "Switch (other)" agent-shell-sidebar-toggle-focus)]]
    [
     :class transient-column
     ("q" "Quit" transient-quit-one)]))

(use-package agent-shell-sidebar
  :after agent-shell
  :straight (:host github :repo "cmacrae/agent-shell-sidebar"))

(use-package agent-shell-macext
  :straight (:host github :repo "cxa/agent-shell-macext")
  :if my:osx
  :hook (agent-shell-mode . agent-shell-macext-setup)
  :custom
  (agent-shell-macext-file-copy-policy 'auto)    ; auto, always-copy, always-original
  (agent-shell-macext-notifications t)           ; enable native notifications
  (agent-shell-macext-notify-current-buffer nil) ; nil = suppress when shell/viewport is current and Emacs is focused
  )
