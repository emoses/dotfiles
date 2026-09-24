;;; cedar-schema-ts-mode.el --- Major mode for Cedar Schema using tree-sitter -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; Author:
;; Version: 0.1.0
;; Package-Requires: ((emacs "29.1"))
;; Keywords: languages cedar schema
;; URL:

;;; Commentary:

;; Major mode for editing Cedar Schema files with tree-sitter support.
;; Provides syntax highlighting and indentation for Cedar Schema.

;;; Code:

(require 'treesit)

(declare-function treesit-parser-create "treesit.c")
(declare-function treesit-node-type "treesit.c")
(declare-function treesit-node-start "treesit.c")
(declare-function treesit-node-end "treesit.c")

(defcustom cedar-schema-ts-mode-indent-offset 2
  "Number of spaces for each indentation step in `cedar-schema-ts-mode'."
  :type 'integer
  :safe 'integerp
  :group 'cedar-schema)

(defvar cedar-schema-ts-mode--syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?/  ". 12" table)
    (modify-syntax-entry ?\n ">"    table)
    (modify-syntax-entry ?_  "w"    table)
    (modify-syntax-entry ?\" "\""   table)
    table)
  "Syntax table for `cedar-schema-ts-mode'.")

(defvar cedar-schema-ts-mode--indent-rules
  `((cedarschema
     ((node-is "}") parent-bol 0)
     ((node-is "]") parent-bol 0)
     ((node-is ")") parent-bol 0)
     ((parent-is "namespace") parent-bol cedar-schema-ts-mode-indent-offset)
     ((parent-is "rec_type") parent-bol cedar-schema-ts-mode-indent-offset)
     ((parent-is "applies_to") parent-bol cedar-schema-ts-mode-indent-offset)
     ((parent-is "app_decls") first-sibling 0)
     ((parent-is "attr_decls") first-sibling 0)
     ((parent-is "ent_or_typs") parent-bol cedar-schema-ts-mode-indent-offset)
     ((parent-is "ref_or_refs") parent-bol cedar-schema-ts-mode-indent-offset)
     ((parent-is "entity") parent-bol cedar-schema-ts-mode-indent-offset)
     ((parent-is "action") parent-bol cedar-schema-ts-mode-indent-offset)
     ((parent-is "type_decl") parent-bol cedar-schema-ts-mode-indent-offset)
     (no-node parent-bol 0)))
  "Tree-sitter indent rules for `cedar-schema-ts-mode'.")

(defvar cedar-schema-ts-mode--font-lock-settings
  (treesit-font-lock-rules
   :language 'cedarschema
   :feature 'comment
   '((comment) @font-lock-comment-face)

   :language 'cedarschema
   :feature 'keyword
   '(["namespace" "entity" "action" "type" "in" "enum"
      "appliesTo" "principal" "resource" "context" "tags"
      "Set"] @font-lock-keyword-face)

   :language 'cedarschema
   :feature 'annotation
   '((annotation "@" @font-lock-preprocessor-face)
     (annotation (IDENT) @font-lock-preprocessor-face))

   :language 'cedarschema
   :feature 'string
   '((STR) @font-lock-string-face)

   :language 'cedarschema
   :feature 'type
   '((TYPENAME) @font-lock-type-face
     (ent_type (path) @font-lock-type-face)
     (type (path) @font-lock-type-face))

   :language 'cedarschema
   :feature 'variable
   '((name (IDENT) @font-lock-variable-name-face)
     (attr_decls (name) @font-lock-property-face))

   :language 'cedarschema
   :feature 'punctuation
   '(["(" ")" "{" "}" "[" "]" "::" ":" "," ";" "?" "@" "<" ">"] @font-lock-punctuation-face)

   :language 'cedarschema
   :feature 'operator
   '(["="] @font-lock-operator-face))
  "Tree-sitter font-lock settings for `cedar-schema-ts-mode'.")

;;;###autoload
(define-derived-mode cedar-schema-ts-mode prog-mode "Cedar Schema"
  "Major mode for editing Cedar Schema files with tree-sitter support."
  :syntax-table cedar-schema-ts-mode--syntax-table

  (when (treesit-ready-p 'cedarschema)
    (treesit-parser-create 'cedarschema)

    ;; Indentation
    (setq-local treesit-simple-indent-rules cedar-schema-ts-mode--indent-rules)

    ;; Font-lock
    (setq-local treesit-font-lock-settings cedar-schema-ts-mode--font-lock-settings)
    (setq-local treesit-font-lock-feature-list
                '((comment keyword)
                  (string type)
                  (annotation variable punctuation)
                  (operator)))

    ;; Comments
    (setq-local comment-start "// ")
    (setq-local comment-end "")

    (treesit-major-mode-setup)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.cedarschema\\'" . cedar-schema-ts-mode))

(provide 'cedar-schema-ts-mode)

;;; cedar-schema-ts-mode.el ends here
