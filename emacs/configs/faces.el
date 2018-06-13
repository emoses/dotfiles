;;;Basic colors
(set-face-background 'mode-line "white")
(set-face-foreground 'mode-line "black")
;(setq default-frame-alist
;      '((background-color . "black")
;      (foreground-color . "white")
;      (cursor-color . "lightgray")))

(use-package base16-theme
  :ensure t
  :init
  (load-theme 'base16-tomorrow-night))

;;;Set up my favorite syntax-hilighting colors
;;(cond ((fboundp 'global-font-lock-mode)
;;       ;; Customize face attributes
;;       (setq font-lock-face-attributes
;;             ;; Symbol-for-Face Foreground Background Bold Italic Underline
;;             '((font-lock-comment-face       "Green4" nil nil t)
;;               (font-lock-string-face        "light sky blue")
;;               (font-lock-keyword-face       "pale turquoise" nil t)
;;	       (font-lock-builtin-face       "pale turquoise" nil t)
;;               (font-lock-function-name-face "aquamarine")
;;	       (font-lock-preprocessor-face  "SkyBlue3")
;;               (font-lock-variable-name-face "turquoise")
;;               (font-lock-type-face          "SkyBlue")
;;;               (font-lock-reference-face     "pale green")
;;	       (font-lock-constant-face      "pale green")
;;	       ;;CPerl-mode specific
;;;              (cperl-nonoverridable-face    "sea green")
;;;              (cperl-hash-face              "turquoise" nil nil t t)
;;;	       (cperl-array-face             "turquoise" nil nil nil t)
;;	       ))
;;       ;; Load the font-lock package.
;;       (require 'font-lock)
;;       ;; Maximum colors
;;       (setq font-lock-maximum-decoration t)
;;       ;; Turn on font-lock in all modes that support it
;;       (global-font-lock-mode t)))

;; Make Fira Code ligatures work
(defun my:frame-font-setup (frame)
  (when (and (display-graphic-p frame) (find-font (font-spec :name "Fira Code")))
    (set-frame-font "Fira Code")))
(mapc #'my:frame-font-setup (frame-list))
(add-hook 'after-make-frame-functions #'my:frame-font-setup)


;; (let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
;;                (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
;;                (36 . ".\\(?:>\\)")
;;                (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
;;                (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
;;                (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
;;                (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
;;                (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
;; ;; doesn't work for cider               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
;;                (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
;;                (48 . ".\\(?:x[a-zA-Z]\\)")
;;                (58 . ".\\(?:::\\|[:=]\\)")
;;                (59 . ".\\(?:;;\\|;\\)")
;;                (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
;;                (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
;;                (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
;;                (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
;;                (91 . ".\\(?:]\\)")
;;                (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
;;                (94 . ".\\(?:=\\)")
;;                (119 . ".\\(?:ww\\)")
;;                (123 . ".\\(?:-\\)")
;;                (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
;;                (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
;;                )
;;              ))
;;   (dolist (char-regexp alist)
;;     (set-char-table-range composition-function-table (car char-regexp)
;;                           `([,(cdr char-regexp) 0 font-shape-gstring]))))
