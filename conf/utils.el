(use-package centaur-tabs
  :ensure t
  :commands (centaur-tabs-mode centaur-tabs-local-mode)
  :custom
  (centaur-tabs-style "bar")
  (centaur-tabs-set-bar 'left)
  (x-underline-at-descent-line t)
  (centaur-tabs-set-close-button nil)
  (centaur-tabs-close-button "×")
  (centaur-tabs-height 28)
  (centaur-tabs-set-icons t)
  (centaur-tabs-gray-out-icons 'buffer)
  (centaur-tabs-cycle-scope 'tabs)
  (centaur-tabs-enable-ido-completion nil)
  (centaur-tabs-show-new-tab-button nil)
  (centaur-tabs-plain-icons t)
  :config
  (centaur-tabs-headline-match)
  (centaur-tabs-group-by-projectile-project)
  (centaur-tabs-change-fonts bg--variable-pitch-font bg--default-font-size)
  (defun centaur-tabs-buffer-groups ()
    (list
     (cond
      ((not (eq (file-remote-p (buffer-file-name)) nil))
       "Remote")
      ((derived-mode-p 'eshell-mode 'term-mode 'shell-mode 'vterm-mode)
       "Term")
      ((or (string-equal "*" (substring (buffer-name) 0 1))
           (memq major-mode '(magit-process-mode
                              magit-status-mode
                              magit-diff-mode
                              magit-log-mode
                              magit-file-mode
                              magit-blob-mode
                              magit-blame-mode)))
       "Emacs")
      ((derived-mode-p 'prog-mode)
       "Editing")
      ((derived-mode-p 'dired-mode)
       "Dired")
      ((memq major-mode '(helpful-mode
                          help-mode))
       "Help")
      ((memq major-mode '(org-mode
                          org-agenda-clockreport-mode
                          org-src-mode
                          org-agenda-mode
                          org-beamer-mode
                          org-indent-mode
                          org-bullets-mode
                          org-cdlatex-mode
                          org-agenda-log-mode
                          diary-mode))
       "OrgMode")
      (t
       (centaur-tabs-get-group-name (current-buffer))))))

  (defun centaur-tabs-hide-tab (x)
    "Do no to show buffer X in tabs."
    (let ((name (format "%s" x)))
      (or
       ;; Current window is not dedicated window.
       (window-dedicated-p (selected-window))

       ;; Buffer name not match below blacklist.
       (string-prefix-p "*epc" name)
       (string-prefix-p "*Compile-Log*" name)
       (string-prefix-p "*Async-native*" name)
       (string-prefix-p "*lsp" name)
       (string-prefix-p "*Flycheck" name)
       (string-prefix-p "*tramp" name)
       (string-prefix-p " *Mini" name)
       (string-prefix-p "*help" name)
       (string-prefix-p "*which-key*" name)
       (string-prefix-p "*straight" name)
       (string-prefix-p " *temp" name)
       (string-prefix-p "*Help" name)
       (string-prefix-p "*mybuf" name)

       ;; Is not magit buffer.
       (and (string-prefix-p "magit" name)
            (not (file-name-extension name))))))
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward)
  ("C-M-<prior>" . centaur-tabs-backward-group)
  ("C-M-<next>" . centaur-tabs-forward-group))
