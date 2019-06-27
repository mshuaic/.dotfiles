(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(matlab-mode jedi-direx py-autopep8 material-theme flycheck elpy ein jedi better-defaults))
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
(unless package--initialized (package-initialize))
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



;; set beep off
 (setq visible-bell 1)

;; (global-set-key (kbd "<f5>") 'switch-to-buffer); switch buffer
;; (global-set-key (kbd "<f6>") 'find-file); find file
;; (global-set-key (kbd "<f12>") 'keyboard-escape-quit) ;; all platforms?


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
;; (global-unset-key (kbd "C-x f"))
;; (global-set-key (kbd "C-x f") 'find-file)

;; (global-unset-key (kbd "<C-right>"))
;; (global-unset-key (kbd "<C-left>"))
(windmove-default-keybindings 'ctrl)

(menu-bar-mode -1)


;; backup on every save, not just the first.
(setq vc-make-backup-files t)
(setq backup-by-copying t      ; don't clobber symlinks
      backup-directory-alist
      '(("." . "~/.saves/"))    ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)       ; use versioned backups

(normal-erase-is-backspace-mode 0)
(add-hook 'prog-mode-hook #'hs-minor-mode)
(global-set-key (kbd "M-[ 1 ; 6 k") 'hs-show-all) ;; ctrl +
(global-set-key (kbd "M-[ 1 ; 5 k") 'hs-hide-level) ;; ctrl =
(global-set-key (kbd "M-[ 1 ; 5 m") 'hs-toggle-hiding) ;; ctrl -


;; add matlab-mode to prog-mode
(add-hook 'matlab-mode-hook
          (lambda () (run-hooks 'prog-mode-hook)))
(put 'matlab-mode 'derived-mode-parent 'prog-mode)

;; hook all prog-mode to auto-complete-mode
(add-hook 'prog-mode-hook 'auto-complete-mode)


(setq initial-scratch-message nil)


(auto-save-visited-mode 1)

;; auto refresh all buffers
(global-auto-revert-mode 1)

(setq ac-ignore-case 'smart)


;; LATEX CONFIGURATION
;; --------------------------------------

(add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of `latex-mode`
(add-to-list 'ac-modes 'LaTeX-mode)   ; make auto-complete aware of `latex-mode`
(add-hook 'LaTeX-mode-hook (lambda ()
	(TeX-fold-mode 1)                             
	(outline-minor-mode 1)
	;; {table}
	;; (add-to-list 'TeX-fold-env-spec-list '("[tabularx]" ("tabularx")))
	;; (add-to-list 'LaTeX-fold-env-spec-list '("[figure]" ("figure")))
	;; (add-to-list 'TeX-fold-env-spec-list '(("[table]" ("table"))))
	(add-hook 'find-file-hook 'TeX-fold-buffer)
	;; (add-to-list 'TeX-fold-env-spec-list '("[figure]" ("figure")))
	;; (add-hook 'find-file-hook 'TeX-fold-dwim)
	;; (add-hook 'find-file-hook 'TeX-fold-comment) 
	;; (TeX-fold-comment 1)
	;; (turn-on-reftex 1)
	;; (setq reftex-plug-into-AUCTeX t)
	(outline-hide-sublevels 3)
	(local-set-key (kbd "M-[ 1 ; 6 k") 'outline-show-entry)
	(local-set-key (kbd "M-[ 1 ; 5 k") 'outline-hide-body)
	(local-set-key (kbd "M-[ 1 ; 5 m") 'outline-toggle-children)
	(LaTeX-math-mode 1)
	;; (flyspell-mode 1)
	(set (make-variable-buffer-local 'TeX-electric-math)
	     (cons "$" "$"))))


;; FLYSPELL CONFIGURATION
;; --------------------------------------
(setq ispell-dictionary "english"); Default dictionary. To change do M-x ispell-change-dictionary RET.
(add-hook 'text-mode-hook 'flyspell-mode)
;; (add-hook 'prog-mode-hook 'flyspell-prog-mode)
(ac-flyspell-workaround) ; fixes a known bug of delay due to flyspell (if it is there)


;; (autoload 'markdown-mode "markdown-mode"
;;    "Major mode for editing Markdown files" t)
;; (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
;; (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; (autoload 'gfm-mode "markdown-mode"
;;    "Major mode for editing GitHub Flavored Markdown files" t)
;; (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))


(defun delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))



(defun my-delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (delete-region
   (point)
   (progn
     (forward-word arg)
     (point))))

(defun my-backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (my-delete-word (- arg)))

(defun my-delete-line ()
  "Delete text from current position to end of line char.
This command does not push text to `kill-ring'."
  (interactive)
  (delete-region
   (point)
   (progn (end-of-line 1) (point)))
  (delete-char 1))

(defun my-delete-line-backward ()
  "Delete text between the beginning of the line to the cursor position.
This command does not push text to `kill-ring'."
  (interactive)
  (let (p1 p2)
    (setq p1 (point))
    (beginning-of-line 1)
    (setq p2 (point))
    (delete-region p1 p2)))

; bind them to emacs's default shortcut keys:
(global-set-key (kbd "C-S-k") 'my-delete-line-backward) ; Ctrl+Shift+k
(global-set-key (kbd "C-k") 'my-delete-line)
(global-set-key (kbd "M-d") 'my-delete-word)
;; Traditionally, Unix uses the ^H keystroke to send a backspace from or to a terminal.
;; swap the <Backspace> and <DEL> keys inside Emacs
(keyboard-translate ?\C-h ?\C-?)
(global-set-key (kbd "M-<DEL>") 'my-backward-delete-word)
