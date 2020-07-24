;;;Useful for all sorts of programming
(global-set-key "\M-g" 'goto-line)
;;the delete key translates as "kp-delete" on macs
(global-set-key (kbd "<deletechar>") 'delete-char)
(global-set-key (kbd "C-<delete>") 'kill-word)
(global-set-key (kbd "C-<DEL>") 'backward-kill-word)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key '[delete] 'delete-char)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "<f9>") 'magit-status)
(global-set-key (kbd "C-c C-r") 'revert-buffer)
(global-set-key (kbd "C-c m") 'switch-to-minibuffer)
(global-set-key (kbd "TAB") 'indent-for-tab-command)
(global-set-key (kbd "A-v") 'yank) ;;for non-evil yanking
(global-set-key (kbd "C-`") 'other-frame) ;;mac-like frame switching
(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-c c _") 'snake-case-region-or-word)
(global-set-key (kbd "C-c c -") 'kebab-case-region-or-word)
(global-set-key (kbd "C-c c c") 'lower-camel-case-region-or-word)
(global-set-key (kbd "C-c c C") 'camel-case-region-or-word)
(global-set-key (kbd "<f5>") 'next-error)
(global-set-key (kbd "S-<f5>") 'previous-error)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x 4 C-]") 'xref-find-definitions-other-window)

;;; If I'm using a terminal, set delete to backwards delete
;;; I find this fixes a lot of the trouble I have with the delete button
(cond ((not window-system)
	    (global-set-key (kbd "<deletechar>") 'backward-delete-char)
	    ))
