;;; cedar-mode.el --- Major mode for Cedar policy language using tree-sitter -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; Author:
;; Version: 0.1.0
;; Package-Requires: ((emacs "29.1"))
;; Keywords: languages cedar policy
;; URL:

;;; Commentary:

;; Major mode for editing Cedar policy files with tree-sitter support.
;; Provides syntax highlighting and indentation for Cedar policy language.

;;; Code:

(require 'treesit)

(declare-function treesit-parser-create "treesit.c")
(declare-function treesit-node-type "treesit.c")
(declare-function treesit-node-start "treesit.c")
(declare-function treesit-node-end "treesit.c")

(defcustom cedar-mode-indent-offset 2
  "Number of spaces for each indentation step in `cedar-mode'."
  :type 'integer
  :safe 'integerp
  :group 'cedar)

(defvar cedar-mode--syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?/  ". 12" table)
    (modify-syntax-entry ?\n ">"    table)
    (modify-syntax-entry ?_  "w"    table)
    (modify-syntax-entry ?\" "\""   table)
    table)
  "Syntax table for `cedar-mode'.")

(defvar cedar-mode--indent-rules
  `((cedar
     ((node-is ")") parent-bol 0)
     ((node-is "}") parent-bol 0)
     ((node-is "]") parent-bol 0)
     ((node-is ",") parent-bol cedar-mode-indent-offset)
     ((parent-is "scope") grand-parent cedar-mode-indent-offset)
     ((parent-is "principal_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "principal_eq_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "principal_in_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "principal_is_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "action_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "action_eq_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "action_in_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "action_in_list_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "resource_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "resource_eq_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "resource_in_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "resource_is_constraint") grand-parent cedar-mode-indent-offset)
     ((parent-is "condition") parent-bol cedar-mode-indent-offset)
     ((parent-is "record_literal") parent-bol cedar-mode-indent-offset)
     ((parent-is "set_literal") parent-bol cedar-mode-indent-offset)
     ((parent-is "entlist") parent-bol cedar-mode-indent-offset)
     ((parent-is "if_then_else") parent-bol cedar-mode-indent-offset)
     ((parent-is "argument_list") parent-bol cedar-mode-indent-offset)
     ((parent-is "policy") parent-bol cedar-mode-indent-offset)
     (no-node parent-bol 0)))
  "Tree-sitter indent rules for `cedar-mode'.")

(defvar cedar-mode--font-lock-settings
  (treesit-font-lock-rules
   :language 'cedar
   :feature 'comment
   '((comment) @font-lock-comment-face)

   :language 'cedar
   :feature 'keyword
   '([(permit) (forbid) (when) (unless) (principal) (action) (resource) (context)] @font-lock-keyword-face
     ["in" "is" "has" "like" "if" "then" "else"] @font-lock-keyword-face)

   :language 'cedar
   :feature 'constant
   '([(true) (false)] @font-lock-constant-face)

   :language 'cedar
   :feature 'annotation
   '((annotation "@" @font-lock-preprocessor-face)
     (annotation (identifier) @font-lock-preprocessor-face))

   :language 'cedar
   :feature 'string
   '((str) @font-lock-string-face)

   :language 'cedar
   :feature 'number
   '((int) @font-lock-number-face)

   :language 'cedar
   :feature 'type
   '((entity (path) @font-lock-type-face))

   :language 'cedar
   :feature 'variable
   '((identifier) @font-lock-variable-name-face)

   :language 'cedar
   :feature 'operator
   '(["==" "!=" "<" "<=" ">" ">=" "+" "-" "*" "&&" "||" "!"] @font-lock-operator-face))
  "Tree-sitter font-lock settings for `cedar-mode'.")

;;;###autoload
(define-derived-mode cedar-mode prog-mode "Cedar"
  "Major mode for editing Cedar policy files with tree-sitter support."
  :syntax-table cedar-mode--syntax-table

  (when (treesit-ready-p 'cedar)
    (treesit-parser-create 'cedar)

    ;; Indentation
    (setq-local treesit-simple-indent-rules cedar-mode--indent-rules)

    ;; Font-lock
    (setq-local treesit-font-lock-settings cedar-mode--font-lock-settings)
    (setq-local treesit-font-lock-feature-list
                '((comment keyword)
                  (string number constant type)
                  (annotation variable punctuation)
                  (operator)))

    ;; Comments
    (setq-local comment-start "// ")
    (setq-local comment-end "")

    (treesit-major-mode-setup)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.cedar\\'" . cedar-mode))

(provide 'cedar-mode)
;;; cedar-mode.el ends here
