(use-package chatgpt-shell
  :straight (:type git :host github :repo "xenodium/chatgpt-shell")
  :config
  (setq chatgpt-shell-openai-key
        (lambda ()
          (auth-source-pick-first-password :host "api.openai.com"))))
