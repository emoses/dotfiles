;;;Basic colors
(set-face-background 'mode-line "white")
(set-face-foreground 'mode-line "black")
(setq default-frame-alist
      '((background-color . "black")
      (foreground-color . "white")
      (cursor-color . "lightgray")))

(setq evil-default-cursor t)
(load-theme 'base16-tomorrow)

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
