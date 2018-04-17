(defun lisp-modes ()
  (paredit-mode t)
  (show-paren-mode t)
  (rainbow-delimiters-mode t))

(use-package evil-paredit
  :ensure t)

(use-package rainbow-delimiters
  :ensure t)

(use-package paredit
  :ensure t
  :bind (:map paredit-mode-map
              ([C-right] . forward-word)
              ([C-left] . backward-word)
              ([M-right] . paredit-forward-slurp-sexp)
              ([M-left] . paredit-forward-barf-sexp))
  :config
  (evil-paredit-mode t)
  )

(use-package clojure-mode
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'lisp-modes))

(use-package cider
  :ensure t
  :pin melpa-stable
  :bind (("M-/" . cider-find-var)
         ("C-c C-t j" . cider-test-jump))
  :config
  (when (eq system-type 'windows-nt)
    (setq cider-lein-command "lein.bat"))
  (setq cider-cljs-lein-repl
        "(do (require 'figwheel-sidecar.repl-api)
         (figwheel-sidecar.repl-api/start-figwheel!)
         (figwheel-sidecar.repl-api/cljs-repl))"))

;; Must use either cider or inf-clojure
;; (use-package inf-clojure
;;   :ensure t
;;   :config
;;   (add-hook 'clojure-mode-hook #'inf-clojure-minor-mode)
;;   (setq inf-clojure-program '("localhost" . 5555)))

(add-hook 'emacs-lisp-mode-hook #'lisp-modes)


(add-hook 'cider-repl-mode-hook
	  (lambda ()
	    ;(paredit-mode t)
	    (show-paren-mode t)
	    (rainbow-delimiters-mode t)))

(setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")
