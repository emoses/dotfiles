;;;Useful for all sorts of programming
(global-set-key "\M-g" 'goto-line)
;;the delete key translates as "kp-delete" on macs
(global-set-key '[C-delete] 'kill-word)
(global-set-key (quote [C-backspace]) 'backward-kill-word)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key '[C-x v space] 'select-cvs)
(global-set-key '[delete] 'delete-char)

;;; If I'm using a terminal, set delete to backwards delete
;;; I find this fixes a lot of the trouble I have with the delete button
(cond ((not window-system)
	    (global-set-key (kbd "<deletechar>") 'backward-delete-char)
	    ))
