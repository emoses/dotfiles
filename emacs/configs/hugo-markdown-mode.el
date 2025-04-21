;;; hugo-markdown-mode.el --- A mode for editing hugo-flavored markdown -*- lexical-binding:t -*-

;; Copyright (C) 2023 Evan Moses

;; Author: Evan Moses <evan@emoses.org>
;; Maintainer: Evan Moses <evan@emoses.org>
;; Keywords: markdown, hugo
;; Version: 0.1
;; Package-Requires: (markdown-mode)
;; Created: December 29, 2023

;; This file is not part of GNU Emacs

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; markdown-mode, but with an extension to ensure that fill-paragraph doesn't break a shortcode.

;;; Code:

(require 'markdown-mode)

(defun hugo-shortcode-nobreak-p ()
  "Don't break between a shortcode opening and the shortcode name.
Intended to be used by `fill-nobreak-predicate'.

              {{< code arg1=arg2 >}}
Don't break here ^    ^-- but here is OK"
  (save-excursion
    (skip-syntax-backward "w")
    (skip-chars-backward " /")
    (re-search-backward "{{[<%]" (- (point) 3) t)))

(defvar hugo-markdown-fill-paragraph-column 90)

(defun hugo-markdown--guess-code-block-comment-fill-prefix ()
  "If we're in a code block, guess that lines starting with '//',
'#', or ';' are comments for the purposes of filling"
  (let* ((line-string (buffer-substring-no-properties
                       (line-beginning-position) (line-end-position)))
         (line-comment-start
          (when
              (string-match "^\\([[:space:]]*\\(?:;+\\|#\\|//\\)[[:space:]]*\\)" line-string)
            (match-string 1 line-string))))
    (or line-comment-start fill-prefix)))

(defun hugo-markdown-fill-paragraph (&optional justify)
  "Markdown mode supresses filling in code blocks, but I want it to
fill so it lays out nicely in a fixed-width chroma block.  So set
this up instead."
  (interactive "P")
  (if (markdown-code-block-at-point-p)
      (let ((fill-column hugo-markdown-fill-paragraph-column)
            (fill-paragraph-function nil)
            (fill-paragraph-handle-comment t)
            (fill-forward-paragraph-function #'forward-line)
            (fill-prefix (hugo-markdown--guess-code-block-comment-fill-prefix)))
        (fill-paragraph justify))
    (markdown-fill-paragraph justify)))


(define-derived-mode hugo-markdown-mode markdown-mode "Hugo Markdown"
  "Major mode for editing Hugo markdown."
  (add-hook 'fill-nobreak-predicate #'hugo-shortcode-nobreak-p nil t)
  (setq-local fill-paragraph-function #'hugo-markdown-fill-paragraph))

(provide 'hugo-markdown-mode)

;; End:
;;; hugo-markdown-mode.el ends here
