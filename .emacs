(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(py-autopep8 material-theme flycheck elpy ein jedi better-defaults))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(unless package--initialized (package-initialize t))
;; (package-initialize)


(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    jedi
    ein
    elpy
    flycheck
    material-theme
    py-autopep8))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

;; PYTHON CONFIGURATION
;; --------------------------------------

;; (elpy-enable)
;; ;;(elpy-use-ipython)
;; ;;(setq python-shell-interpreter "ipython"
;; ;;      python-shell-interpreter-args "-i --simple-prompt")
;; (setq python-shell-interpreter "python"
;;       python-shell-interpreter-args "-i")



;; use flycheck not flymake with elpy
;; (when (require 'flycheck nil t)
;;   (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;   (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)


(global-auto-complete-mode t)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
   
(global-linum-mode t)

(setq visible-cursor nil)

(global-unset-key (kbd "C-_"))
(global-set-key (kbd "C-_") 'comment-line) 
(global-set-key (kbd "C-z") 'undo)

;; no confirmation for killing processes when exit file
(setq confirm-kill-processes nil)

(xterm-mouse-mode 1)

;; display buffer vertically
(setq split-width-threshold 1) 
;; (setq split-height-threshold nil)


;; Traditionally, Unix uses the ^H keystroke to send a backspace from or to a terminal.
(keyboard-translate ?\C-h ?\C-?)


;; set beep off
 (setq visible-bell 1)

(global-set-key (kbd "<f5>") 'switch-to-buffer); switch buffer
(global-set-key (kbd "<f6>") 'find-file); find file
(global-set-key (kbd "<f12>") 'keyboard-escape-quit) ;; all platforms?


;; use xclip to copy/paste in emacs-nox
(unless window-system
  (when (getenv "DISPLAY")
    (defun xclip-cut-function (text &optional push)
      (with-temp-buffer
	(insert text)
	(call-process-region (point-min) (point-max) "xclip" nil 0 nil "-i" "-selection" "clipboard")))
    (defun xclip-paste-function()
      (let ((xclip-output (shell-command-to-string "xclip -o -selection clipboard")))
	(unless (string= (car kill-ring) xclip-output)
	  xclip-output )))
    (setq interprogram-cut-function 'xclip-cut-function)
    (setq interprogram-paste-function 'xclip-paste-function)
        ))

;; auto pair
(electric-pair-mode 1)

;; unset key
(global-unset-key (kbd "C-x f"))
(global-set-key (kbd "C-x f") 'find-file)

;; (global-unset-key (kbd "<C-right>"))
;; (global-unset-key (kbd "<C-left>"))
(windmove-default-keybindings 'ctrl)

(menu-bar-mode -1)
