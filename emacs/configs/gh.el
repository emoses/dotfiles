(setq gh-profile-alist
       `(("github-emoses"
         :username "emoses"
         :token ,(cdr (assoc "github-emoses-token" secrets-alist))
         :remote-regexp "^\\(?:git@github\\.com-emoses:\\|\\(?:git\\|https?\\|ssh\\)://.*@?github\\.com/\\)\\(.*\\)/\\(.*\\)\\(?:\\.git\\)?"
         :url "https://api.github.com")))

(setq gh-profile-default-profile "github-emoses")
