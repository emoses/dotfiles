(add-hook 'clojure-mode-hook
	  (lambda ()
	    (paredit-mode t)
	    (show-paren-mode)))

(eval-after-load 'paredit
  '(progn
     (define-key paredit-mode-map (kbd "C-<right>") 'forward-word)
     (define-key paredit-mode-map (kbd "C-<left>") 'backward-word)
     (define-key paredit-mode-map (kbd "M-<right>") 'paredit-forward-slurp-sexp)
     (define-key paredit-mode-map (kbd "M-<left>") 'paredit-forward-barf-sexp)))


