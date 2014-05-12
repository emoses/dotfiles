;;;Useful for all sorts of programming
(global-set-key "\M-g" 'goto-line)
;;the delete key translates as "kp-delete" on macs
(global-set-key (kbd "C-<delete>") 'kill-word)
(global-set-key (kbd "C-<DEL>") 'backward-kill-word)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key '[delete] 'delete-char)
(global-set-key (kbd "C-x f") 'find-file-in-repository)
(global-set-key (kbd "C-c C-a") 'aura-switch-to-ext)
(global-set-key (kbd "C-c 4 a") 'aura-switch-to-ext-other-window)

;;; If I'm using a terminal, set delete to backwards delete
;;; I find this fixes a lot of the trouble I have with the delete button
(cond ((not window-system)
	    (global-set-key (kbd "<deletechar>") 'backward-delete-char)
	    ))
