(setq gh-profile-alist
       `(("github-emoses"
         :username "emoses"
         :token ,(cdr (assoc "github-emoses-token" secrets-alist))
         :remote-regexp "^\\(?:git@github\\.com-emoses:\\|\\(?:git\\|https?\\|ssh\\)://.*@?github\\.com/\\)\\(.*\\)/\\(.*\\)\\(?:\\.git\\)?"
         :url "https://api.github.com")
        ("github-emosesSfdc"
         :username "emosesSfdc"
         :token ,(cdr (assoc "github-emosesSfdc-token" secrets-alist))
         :url "https://api.github.com"
         :remote-regexp "^\\(?:git@github\\.com-emosesSfdc:\\|\\(?:git\\|https?\\|ssh\\)://.*@?github\\.com/\\)\\(.*\\)/\\(.*\\)\\(?:\\.git\\)?")))

(setq gh-profile-default-profile "github-emosesSfdc")
