(use-package pyenv-mode
  :ensure t)

(use-package elpy
  :ensure t
  :bind (:map elpy-mode-map
              ("M-/" . elpy-goto-definition))
  :config
  (pyenv-mode)
  (elpy-enable)
  (setq elpy-rpc-python-command "python3")
  (setq python-shell-interpreter "python3"))
