(add-to-list 'load-path "~/emacs/slime")
(require 'slime)
(eval-after-load 'slime '(setq slime-protocol-version 'ignore))
(slime-setup '(slime-repl))

(add-to-list 'load-path "~/emacs/clojure-mode")
(require 'clojure-mode)
(require 'clojure-test-mode)

(add-hook 'clojure-mode-hook
	  (lambda () (show-paren-mode t)))