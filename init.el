;; Require and initialize `package`.
(require 'package)
(package-initialize)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)


(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))


(defvar conf-dir (expand-file-name "conf" user-emacs-directory) "The directory for config files.")

(add-to-list 'load-path conf-dir)

(defvar conf-files
  '("core.el"
    "themes.el"
    "dev.el"
    "clojure.el"
    "org-config.el"
    "utils.el"
    )
  )

(dolist (x conf-files)
  (load x))


(defun multiply-by-seven (number)       ; Interactive version.
  "Multiply NUMBER by seven."
  (interactive "p")
  (message "The result is %d" (* 7 number)))

(defun interactive-func(num)
  (interactive "p")
  (message "entered num is %d" num))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eglot-confirm-server-edits nil nil nil "Customized with use-package eglot")
 '(package-selected-packages
   '(all-the-icons-completion all-the-icons-dired apheleia blackout cape centaur-tabs cider clojure-mode consult
                              consult-eglot corfu-prescient csv-mode ctrlf diff-hl doom-modeline ef-themes
                              expand-region flycheck fontaine git-modes git-timemachine go-mode helpful
                              highlight-indent-guides hl-todo jarchive kind-icon ligature marginalia markdown-mode
                              multiple-cursors org-appear org-bars origami paredit pulsar rainbow-delimiters
                              sql-indent tempel treemacs-all-the-icons treemacs-icons-dired treemacs-magit undo-fu
                              use-package vertico-prescient vundo which-key yafolding yaml-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
