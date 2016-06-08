(defun lisp-modes ()
  (paredit-mode t)
  (show-paren-mode)
  (rainbow-delimiters-mode t))


(add-hook 'clojure-mode-hook #'lisp-modes)
(add-hook 'emacs-lisp-mode-hook #'lisp-modes)


(add-hook 'cider-repl-mode-hook
	  (lambda ()
	    ;(paredit-mode t)
	    (show-paren-mode t)
	    (rainbow-delimiters-mode t)))

(eval-after-load 'paredit
  '(progn
     (evil-paredit-mode t)
     (define-key paredit-mode-map (kbd "C-<right>") 'forward-word)
     (define-key paredit-mode-map (kbd "C-<left>") 'backward-word)
     (define-key paredit-mode-map (kbd "M-<right>") 'paredit-forward-slurp-sexp)
     (define-key paredit-mode-map (kbd "M-<left>") 'paredit-forward-barf-sexp)))

(setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")
