;; Disable menu bar
(menu-bar-mode -1)

;; Disable file backups
(setq make-backup-files nil)

;; Disable auto-save
(setq auto-save-default nil)

;; Disable splash screen
(setq inhibit-splash-screen t)

;; Set scratch text to empty
(setq initial-scratch-message nil)

;; Line numbering
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; Package
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Evil
(use-package evil
  :ensure t
  :init
  (setq evil-want-C-u-scroll t)
  (evil-mode 1))

;; Key-chord
(use-package key-chord
  :ensure t
  :config
  (key-chord-mode 1)
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state))

;; Custom
(custom-set-variables
 '(package-selected-packages '(key-chord evil)))
(custom-set-faces)
