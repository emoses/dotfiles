(require 'package)
(package-initialize)
(setq package-enable-at-startup nil)
(setq package-archives `(("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))

(defmacro use-url (name url)
  `(unless (require ',name nil t)
     (with-temp-buffer
       (url-insert-file-contents ,url)
       (eval-buffer)
       (write-file (concat user-emacs-directory
                           (file-name-as-directory "elisp")
                           (concat (symbol-name ',name) ".el"))))))
(use-url quelpa  "https://raw.github.com/quelpa/quelpa/master/bootstrap.el")
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://framagit.org/steckerhalter/quelpa-use-package.git"))
(require 'quelpa-use-package)

(eval-when-compile
  (require 'use-package))

(use-package el-patch
  :ensure t
  :config
  (setq el-patch-enable-use-package-integration t))

(require 'el-patch)
