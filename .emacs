;; Package
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; Use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Disable menu bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Disable file backups
(setq make-backup-files nil)

;; Disable splash screen
(setq inhibit-splash-screen t)

;; Set scratch text to empty
(setq initial-scratch-message nil)

;; Line numbering
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; Enable tabs
(tab-bar-mode 1)
(setq tab-bar-close-button-show nil)
(setq tab-bar-new-button-show nil)

;; Theme
(use-package kaolin-themes
  :ensure t
  :config
  (load-theme 'kaolin-dark t)
  (kaolin-treemacs-theme))

;; Font 
(set-frame-font "CommitMono Nerd Font 11" nil t)

;; Evil
(use-package evil
  :ensure t
  :init
  (setq evil-want-C-u-scroll t)
  (evil-mode 1))

(evil-set-undo-system 'undo-redo)

;; LSP-mode
(use-package lsp-mode
  :ensure t
  :init
  :commands lsp)

;; Key-chord
(use-package key-chord
  :ensure t
  :config
  (setq key-chord-two-keys-delay 1.0)
  (key-chord-mode 1))

;; Quit command with escape
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Exit insert mode with jk
(evil-define-key 'insert 'global (kbd "<key-chord> j k") 'evil-normal-state)

;; Unbind ctrl-t
(evil-define-key 'normal 'global (kbd "C-t") nil)

;; Tabs
(evil-define-key 'normal 'global (kbd "C-t q") 'tab-close)
(evil-define-key 'normal 'global (kbd "C-t l") 'tab-next)
(evil-define-key 'normal 'global (kbd "C-t h") 'tab-previous)
(evil-define-key 'normal 'global (kbd "C-t j") 'tab-first)
(evil-define-key 'normal 'global (kbd "C-t k") 'tab-last)

;; Windows
(evil-define-key 'normal 'global (kbd "M-q") 'delete-window)
(evil-define-key 'normal 'global (kbd "M-l") 'windmove-right)
(evil-define-key 'normal 'global (kbd "M-h") 'windmove-left)
(evil-define-key 'normal 'global (kbd "M-j") 'windmove-down)
(evil-define-key 'normal 'global (kbd "M-k") 'windmove-up)

;; Custom
(custom-set-variables
 '(package-selected-packages '(key-chord evil)))
(custom-set-faces)
