(use-package pyenv-mode
  :ensure t)

(use-package elpy
  :ensure t
  :mode ("\\.py$" . python-mode)
  :bind (:map elpy-mode-map
              ("M-/" . elpy-goto-definition))
  :init
  (pyenv-mode)
  (elpy-enable)
  :config
  (setq elpy-rpc-python-command "python3")
  (setq python-shell-interpreter "python3"))
