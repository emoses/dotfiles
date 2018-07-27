(use-package pyenv-mode
  :ensure t)

(use-package elpy
  :ensure t
  :after flycheck
  :mode ("\\.py$" . python-mode)
  :bind (:map elpy-mode-map
              ("M-/" . elpy-goto-definition)
              ("C-c C-r f" . elpy-autopep8-fix-code)
              ("C-c C-s" . my:projectile-ag-elpy-symbol))
  :init
  (pyenv-mode)
  (elpy-enable)
  :config
  (setq elpy-rpc-python-command "python3")
  (setq python-shell-interpreter "python3")
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode)

  (defun my:projectile-ag-elpy-symbol (search-term &optional arg)
    "Run an ag search for symbol at point, or region if active.

With optional prefix ARG, SEARCH-TERM is treated as a regexp"
    (interactive
     (list
      (let ((symbol
             (if (use-region-p)
                 (buffer-substring-no-properties (region-beginning)
                                                 (region-end))
               (thing-at-point 'symbol))))
        (if (and symbol (not current-prefix-arg))
            symbol
          (projectile--read-search-string-with-default
           (format "Search in project for %s: " (if current-prefix-arg "regexp" "string")))))
      current-prefix-arg))
    (projectile-ag search-term arg)))
