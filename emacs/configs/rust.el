(defun my:rust-mode-hooks ()
    (add-hook 'before-save-hook #'maybe-lsp-format-buffer nil t)
    (add-hook 'rustic-mode-hook (lambda ()
                                  (dap-register-debug-template "Rust::CppTools Run (Auto)"
                                                               (list :type "cppdbg"
                                                                     :request "launch"
                                                                     :name "Rust::Run (GDB/LLDB)"
                                                                     :MIMode (if (eq system-type 'darwin) "lldb" "gdb") ; Choose debugger based on OS
                                                                     ;; You may need to change this to "rust-lldb" or "gdb" depending on your setup
                                                                     :miDebuggerPath "rust-lldb"
                                                                     ;; hard-coded for cedar for now
                                                                     :program "${workspaceFolder}/target/debug/cedar-authorization-sidecar"
                                                                     :cwd "${workspaceFolder}")))
              ))

(use-package rustic
  :mode ("\\.rs$" . rustic-mode)
  :config
  (setq rustic-format-on-save nil)
  (require 'dap-cpptools)
  (dap-cpptools-setup)
  (add-hook 'rust-mode-hook #'my:rust-mode-hooks)
  :custom
  (rustic-cargo-use-last-stored-arguments nil))


