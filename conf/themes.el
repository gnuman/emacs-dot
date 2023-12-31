;; disable all GUI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(use-package fontaine
  :ensure t
  :demand t
  :if (display-graphic-p)
  :init
  (setq fontaine-presets
        `((regular
           :default-height ,220)
          (large
           :default-weight semilight
           :default-height 210
           :bold-weight extrabold)
          (t
           :default-family , "Berkeley Mono"
           :default-weight normal
           :variable-pitch-family , "IBM Plex Sans"
           :variable-pitch-height 1.05)))
  :config
  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular))
  (add-hook 'kill-emacs-hook #'fontaine-store-latest-preset))


(use-package all-the-icons
  :ensure t
  :defer 10
  :if (display-graphic-p)
  :custom
  (all-the-icons-scale-factor 1.1))


(use-package all-the-icons-completion
  :ensure   t
  :after (marginalia all-the-icons)
  :hook
  (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))


(use-package all-the-icons-dired
  :ensure   t
  :after all-the-icons
  :hook
  (dired-mode . all-the-icons-dired-mode))


(use-package doom-modeline
  :ensure   t
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-hud t)
  (doom-modeline-height 25)
  (doom-modeline-bar-width 6)
  (doom-modeline-buffer-encoding nil)
  (doom-modeline-window-width-limit 115)
  (doom-modeline-project-detection 'project)
  (doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))
  :custom-face
  (mode-line ((t (:height 0.90))))
  (mode-line-inactive ((t (:height 0.90)))))

(defun bg/disable-themes ()
  "Disable all enabled custom themes."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes))


(use-package ef-themes
  :ensure   t
  :if (display-graphic-p)
  :demand t
  :custom
  (ef-themes-region '(intense no-extend neutral))
  (ef-themes-variable-pitch-ui nil)
  (ef-themes-disable-other-themes t)
  (ef-themes-to-toggle '(ef-elea-dark ef-elea-light))
  :init
  (defun bg/ef-themes-hl-todo-faces ()
    "Configure `hl-todo-keyword-faces' with Ef themes colors."
    (ef-themes-with-colors
      (setq hl-todo-keyword-faces
            `(("HOLD" . ,yellow)
              ("TODO" . ,red)
              ("NEXT" . ,blue)
              ("OKAY" . ,green-warmer)
              ("DONT" . ,yellow-warmer)
              ("FAIL" . ,red-warmer)
              ("BUG" . ,red-warmer)
              ("DONE" . ,green)
              ("NOTE" . ,blue-warmer)
              ("HACK" . ,cyan)
              ("FIXME" . ,red-warmer)
              ("XXX" . ,red-warmer)
              ("DEPRECATED" . ,yellow)))))
  (bg/disable-themes)
  :config
  (ef-themes-select 'ef-elea-dark))

(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-auto-enabled nil)
  (highlight-indent-guides-character #x258f)
  :config
  (set-face-foreground 'highlight-indent-guides-character-face (ef-themes-get-color-value 'bg-active))
  (set-face-foreground 'highlight-indent-guides-top-character-face (ef-themes-get-color-value 'fg-dim)))

(use-package ligature
  :ensure t
  :demand t
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'org-mode '("ff" "fi" "ffi"))
  (ligature-set-ligatures '(html-mode nxml-mode web-mode) '("<!--" "-->" "</>" "</" "/>" "://"))
  ;; reduced set of useful ligatures
  (ligature-set-ligatures 'prog-mode
                          '("++" "--" "/=" "&&" "||" "||="
                            "<<" "<<<" "<<=" ">>" ">>>" ">>=" "|=" "^="
                            "#{" "#(" "#_" "#_(" "#?" "#:" "~@" ";;" ";;;"
                            "/*" "*/" "/**" "//" "///"
                            "<=" ">=" "<=>"
                            "??"
                            "->" "<-" "<--" "-->" "<>"
                            "==" "===" "!=" "=/=" "!=="
                            "%%"
                            ":="
                            "**"
                            "!!"
                            "##" "###" "####" "---"
                            "#!"
                            ".." "..."
                            "__" "::"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))
