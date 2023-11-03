(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(use-package xref
  :ensure t
  :custom
  (xref-search-program 'ripgrep))


(use-package magit
  :ensure t
  :defer 5
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-diff-refine-hunk t)
  (git-commit-fill-column 72)
  (magit-diff-refine-hunk t)
  (magit-section-highlight-hook nil)
  (magit-define-global-key-bindings nil)
  (magit-log-arguments '("--graph" "--decorate" "--color"))
  :config
  (let ((sans-serif-family (face-attribute 'variable-pitch :family)))
    (set-face-attribute 'magit-diff-file-heading nil :family sans-serif-family :weight 'normal :bold nil)
    (set-face-attribute 'magit-diff-file-heading-highlight nil :family sans-serif-family :weight 'normal :bold nil)
    (set-face-attribute 'magit-section-child-count nil :family sans-serif-family :weight 'normal :bold nil)
    (set-face-attribute 'magit-section-heading nil :family sans-serif-family :bold t)
    (set-face-attribute 'magit-section-highlight nil :family sans-serif-family :bold t))
  :bind
  ("C-x g" . magit-status))


(use-package git-timemachine
  :after magit
  :ensure t
  :bind (:map prog-mode-map
              ("C-c g t" . git-timemachine)))


(use-package git-modes
  :ensure t
  :mode (("\\.gitattributes\\'" . gitattributes-mode)
         ("\\.gitconfig\\'" . gitconfig-mode)
         ("\\.gitignore\\'" . gitignore-mode)))


(use-package diff-hl
  :ensure t
  :after magit
  :hook
  ((magit-pre-refresh . diff-hl-magit-pre-refresh)
   (magit-post-refresh . diff-hl-magit-post-refresh))
  :init
  (setq diff-hl-draw-borders nil)
  :config
  (global-diff-hl-mode))


(use-package hl-todo
  :ensure t
  :init
  (global-hl-todo-mode 1)
  :custom
  (hl-todo-keyword-faces '(("TODO"   . "#BF616A")
                           ("FIXME"  . "#EBCB8B")
                           ("DEBUG"  . "#B48EAD")
                           ("GOTCHA" . "#D08770")
                           ("XXX"   . "#81A1C1"))))


(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode . rainbow-delimiters-mode)
         (emacs-lisp-mode . rainbow-delimiters-mode)))

(use-package blackout
  :ensure t
  :demand t
  :config
  (blackout 'auto-fill-mode)
  (blackout 'eldoc-mode)
  (blackout 'emacs-lisp-mode "EL"))

(use-package markdown-mode
  :ensure t
  :blackout "μ "
  :ensure-system-package (multimarkdown)
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


(use-package yaml-mode :ensure t)


(use-package flycheck
  :ensure t
  :config
  (setq-default flycheck-indication-mode 'left-fringe)
  (setq-default flycheck-highlighting-mode 'columns)
  :hook
  ;; limiting its use because for other langs we have lsp
  ((emacs-lisp-mode . flycheck-mode)
   (flycheck-mode . flycheck-set-indication-mode)))



(use-package paredit
  :ensure t
  :blackout t
  :bind
  (:map paredit-mode-map
        ("M-(" . paredit-wrap-round)
        ("M-{" . paredit-wrap-curly)
        ("{" . paredit-open-curly)
        ("M-[" . paredit-wrap-square)
        ("M-]" . paredit-close-square-and-newline)
        ("C->" . paredit-forward-slurp-sexp)
        ("C-<" . paredit-forward-barf-sexp)
        ("C-M-<" . paredit-backward-slurp-sexp)
        ("C-M->" . paredit-backward-barf-sexp)
        ("RET" . nil)
        ("M-;" . nil)
        ("M-j" . paredit-newline))
  :hook ((clojure-mode . enable-paredit-mode)
         (clojurescript-mode . enable-paredit-mode)
         (clojurec-mode . enable-paredit-mode)
         (cider-repl-mode . enable-paredit-mode))
  ;; (emacs-lisp-mode . enable-paredit-mode)
  ;; (eval-expression-minibuffer-setup . enable-paredit-mode)
  ;; (lisp-interaction-mode . enable-paredit-mode)
  :config
  (show-paren-mode t))

(use-package sql-indent
  :ensure t
  :mode ("\\.sql\\'" . sqlind-minor-mode))


(use-package csv-mode
  :ensure t
  :blackout "CSV"
  :mode ("\\.csv\\'" . csv-mode)
  :custom (csv-align-max-width 115))

(use-package jarchive
  :demand t
  :ensure t)

(use-package blacken
  :defer t
  :custom
  (blacken-allow-py36 t)
  (blacken-skip-string-normalization t)
  :hook (python-mode-hook . blacken-mode))

(use-package python
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :blackout "PI"
  :config
  (setq python-shell-interpreter "python3")
  (setq  python-indent-offset 4)
  (setq python-indent-guess-indent-offset t)
  (setq python-indent-guess-indent-offset-verbose nil))

;; use eglot-mode as lsp client because it's a lot less intrusive
(use-package eglot
  :ensure t
  :bind (:map eglot-mode-map
              ("C-c r" . eglot-rename))
  :hook
  (clojure-mode . eglot-ensure)
  (python-mode . eglot-ensure)
  (go-mode . eglot-ensure)
  :config
  (jarchive-setup)
  (jarchive-patch-eglot)

  :custom
  (eglot-autoshutdown t)
  (eglot-extend-to-xref nil)
  (eglot-confirm-server-initiated-edits nil)
  (eglot-sync-connect nil)
  ;; don't need these features as they are provided from elsewhere
  (eglot-ignored-server-capabilities '(:hoverProvider
                                       :documentOnTypeFormattingProvider
                                       :executeCommandProvider))
  (eglot-connect-timeout 120))

(use-package consult-eglot
  :ensure t
  :after (eglot)
  :commands (consult-eglot-symbols))


(use-package go-mode
  :after (eglot)
  :ensure t
  :mode "\\.go\\'"
  :config
  (setq-default eglot-workspace-configuration
                '((:gopls . ((gofumpt . t))))))


(use-package tempel
  :ensure t
  :custom
  (tempel-trigger-prefix "<")
  (tempel-path (expand-file-name "tempel-templates.el" conf-dir))
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert))
  :init
  ;; Setup completion at point
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))
  :hook
  (prog-mode . tempel-setup-capf)
  (text-mode . tempel-setup-capf))
