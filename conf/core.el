(use-package emacs
  :hook
  ('before-save . #'delete-trailing-whitespace)
  :config
  (setq-default
   indent-tabs-mode nil
   fill-column 115
   truncate-string-ellipsis "…"
   sentence-end-double-space nil
   cursor-type '(hbar .  2)
   cursor-in-non-selected-windows nil)
  (setq
   tab-width 4
   tab-always-indent 'complete
   require-final-newline t
   custom-safe-themes t
   confirm-kill-emacs #'yes-or-no-p
   dired-kill-when-opening-new-dired-buffer t
   completion-cycle-threshold 3
   tab-always-indent 'complete
   version-control t
   kept-new-versions 10
   kept-old-versions 0
   delete-old-versions t
   vc-make-backup-files t
   make-backup-files nil
   use-dialog-box nil
   global-auto-revert-non-file-buffers t
   blink-cursor-mode nil
   history-delete-duplicates t
   default-directory "~/"
   confirm-kill-processes nil)
  (delete-selection-mode t)
  (column-number-mode t)
  (size-indication-mode t)
  (global-hl-line-mode 1)
  (global-auto-revert-mode 1)
  (defalias 'yes-or-no-p 'y-or-n-p)
  (prefer-coding-system 'utf-8)
  (set-charset-priority 'unicode)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-language-environment   'utf-8)
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
		  (replace-regexp-in-string
		   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
		   crm-separator)
		  (car args))
	  (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
	'(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  :bind
  ("C-c q" . #'bury-buffer)
  ("<escape>" . #'keyboard-escape-quit))


(use-package prescient
  :ensure t
  :demand t
  :custom
  (prescient-filter-method '(literal initialism prefix regexp fuzzy))
  (prescient-history-length 1000)
  (prescient-use-char-folding t)
  (prescient-use-case-folding 'smart)
  (prescient-sort-full-matches-first t)
  (prescient-sort-length-enable t)
  :config
    (prescient-persist-mode +1))


(use-package vertico
  :ensure t
  :bind (:map vertico-map
              ("C-." . vertico-repeat)
              ("C-n" . vertico-next)
              ("C-p" . vertico-previous)
              ("C-f" . vertico-exit)
              ("C-M-n" . vertico-next-group)
              ("C-M-p" . vertico-previous-group)
              ("C-<backspace>" . vertico-directory-delete-word))
  :hook
  (minibuffer-setup . vertico-repeat-save)
  :custom
  (vertico-cycle t)
  (vertico-count 10)
  (vertico-resize nil)
  (vertico-preselect 'first)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)
  :init
  (vertico-mode)
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy))


(use-package vertico-prescient
  :ensure t
  :after vertico
  :config
  (vertico-prescient-mode 1))


(use-package marginalia
  :after vertico
  :ensure t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode)
  (setq marginalia-annotators '(marginalia-annotators-heavy
                                marginalia-annotators-light
                                nil)))


(use-package ctrlf
  :ensure t
  :config (ctrlf-mode +1))


(use-package corfu
  :ensure t
  :config
  (defun corfu-complete-and-quit ()
    (interactive)
    (corfu-complete)
    (corfu-quit))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode +1)
  :bind (:map corfu-map
              ("C-n" . corfu-next)
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("C-p" . corfu-previous)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous)
              ("RET" . corfu-complete-and-quit)
              ("<return>" . corfu-complete-and-quit)
              ("C-g" . corfu-quit)
              ("C-q" . corfu-quick-insert)
              ("S-SPC" . corfu-insert-separator)
              ([remap completion-at-point] . corfu-complete)
              ("M-d" . corfu-popupinfo-toggle)
              ("M-p" . corfu-popupinfo-scroll-down)
              ("M-n" . corfu-popupinfo-scroll-up))
  :custom
  (corfu-cycle nil)
  (corfu-auto t)
  (corfu-count 9)
  (corfu-on-exact-match 'quit)
  (corfu-preselect-first t)
  (corfu-quit-at-boundary 'separator)
  (corfu-auto-delay 0.0)
  (corfu-auto-prefix 2)
  (corfu-quit-no-match t)
  (corfu-scroll-margin 5)
  (corfu-max-width 100)
  (corfu-min-width 42)
  (corfu-popupinfo-max-height 20)
  (corfu-popupinfo-max-width 85))


(use-package corfu-prescient
  :ensure t
  :after (prescient corfu)
  :demand t
  :init
  (corfu-prescient-mode +1))


(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file))


(use-package kind-icon
  :ensure t
  :demand t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))



(use-package which-key
  :ensure t
  :hook (emacs-startup . which-key-mode)
  :custom
  (which-key-popup-type 'side-window))


(use-package treemacs
  :ensure t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-indentation                     1
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               60
          treemacs-width                           30
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    (treemacs-resize-icons 20)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-git-commit-diff-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))
    (treemacs-hide-gitignored-files-mode t))
  (treemacs-project-follow-mode 1)
  :bind
  (:map global-map
        ("s-t"       . treemacs-add-and-display-current-project)
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))


(use-package treemacs-icons-dired
  :ensure t
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  )


(use-package treemacs-magit
  :ensure t
  :hook treemacs
  :after (treemacs magit)
  )


(use-package treemacs-all-the-icons
  :ensure t
  :after treemacs)


(use-package whitespace
  :disabled t
  :ensure t
  :commands (whitespace-mode)
  :hook ((prog-mode . whitespace-mode)
         (text-mode . whitespace-mode)
         (before-save . whitespace-cleanup))
  :config
  (setq whitespace-line-column 115)
    (setq whitespace-style '(face tabs empty trailing lines-tail)))



(use-package multiple-cursors
  :ensure t
  :hook (prog-mode . multiple-cursors-mode)
  :bind
  (("C-M-s-. C-M-s-." . mc/edit-lines)
   ("C-)" . mc/mark-next-like-this)
   ("C-(" . mc/mark-previous-like-this)
   ("C-c C-<" . mc/mark-all-like-this)))


(use-package helpful
  :ensure t
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))


(use-package undo-fu
  :ensure t
  :bind (("M-z" . undo-fu-only-undo)
         ("M-Z" . undo-fu-only-redo))
  :init
  (global-unset-key (kbd "C-z")))


(use-package vundo
  :ensure t
  :custom
  (vundo-glyph-alist vundo-unicode-symbols))


(use-package ace-window
  :ensure t
  :bind
  ("M-o" . ace-window))


(use-package avy
  :ensure t
  :bind
  ("M-g M-c" . avy-goto-char-timer)
  ("M-g M-g" . avy-goto-line)
  :config
  (setq avy-background t)
  (defun avy-action-helpful (pt)
    (save-excursion
      (goto-char pt)
      (helpful-at-point))
    (select-window
     (cdr (ring-ref avy-ring 0)))
    t)
  (setf (alist-get ?H avy-dispatch-alist) 'avy-action-helpful))


(use-package hideshow
  :ensure t
  :disabled nil
  :hook
  (prog-mode . hs-minor-mode)
  :config
  (defun kc/hs-cycle (&optional level)
    (interactive "p")
    (let (message-log-max
          (inhibit-message t))
      (if (= level 1)
          (pcase last-command
            ('hs-cycle
             (hs-hide-level 1)
             (setq this-command 'hs-cycle-children))
            ('hs-cycle-children
             ;; TODO: Fix this case. `hs-show-block' needs to be
             ;; called twice to open all folds of the parent
             ;; block.
             (save-excursion (hs-show-block))
             (hs-show-block)
             (setq this-command 'hs-cycle-subtree))
            ('hs-cycle-subtree
             (hs-hide-block))
            (_
             (if (not (hs-already-hidden-p))
                 (hs-hide-block)
               (hs-hide-level 1)
               (setq this-command 'hs-cycle-children))))
        (hs-hide-level level)
        (setq this-command 'hs-hide-level))))

  (defun kc/hs-global-cycle ()
    (interactive)
    (pcase last-command
      ('hs-global-cycle
       (save-excursion (hs-show-all))
       (setq this-command 'hs-global-show))
      (_ (hs-hide-all))))
  :bind
  ("C-tab" . kc/hs-cycle)
  ("C-f-<tab>" . kc/hs-global-cycle))

(use-package pulsar
  :ensure t
  :defer 1
  :init
  (pulsar-global-mode 1)
  :config
  (setq pulsar-pulse t)
  (setq pulsar-delay 0.05)
  (setq pulsar-iterations 13)
  (setq pulsar-face 'pulsar-green)
  (setq pulsar-highlight-face 'pulsar-green)
  :bind
  ("C-x l" . #'pulsar-pulse-line-red)
  ("C-c h h" . #'pulsar-highlight-dwim)
  :hook
  ((next-error . #'pulsar-pulse-line)))


(use-package expand-region
  :ensure t
  :bind
    ("C-=" . #'er/expand-region))


(use-package consult
  :ensure t
  :bind ;; C-c bindings in `mode-specific-map'
  ("C-c M-x" . consult-mode-command)
  ("C-x M-f" . consult-recent-file)
  ("C-c k" . consult-kmacro)
  ("C-c m" . consult-man)
  ("C-c i" . consult-info)
  ([remap Info-search] . consult-info)
  ;; C-x bindings in `ctl-x-map'
  ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
  ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
  ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
  ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
  ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
  ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
  ;; Custom M-# bindings for fast register access
  ("M-#" . consult-register-load)
  ("M-'" . consult-register-store) ;; orig. abbrev-prefix-mark (unrelated)
  ("C-M-#" . consult-register)
  ;; Other custom bindings
  ("M-y" . consult-yank-pop)    ;; orig. yank-pop
  ;; M-g bindings in `goto-map'
  ("M-g g" . consult-goto-line) ;; orig. goto-line

  ;; Minibuffer history
  (:map minibuffer-local-map
        ;; orig. next-matching-history-element
        ("C-r" . consult-history)
        ;; orig. previous-matching-history-element
        ("M-r" . consult-history))

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :custom
  (consult-narrow-key "C-,")
  (consult-widen-key "C-.")
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)

   consult-line
   consult-ripgrep
   :initial (when (use-region-p)
              (buffer-substring-no-properties
               (region-beginning) (region-end)))

   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
      :preview-key '(:debounce 0.4 any)))