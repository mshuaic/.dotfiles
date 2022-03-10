;; (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(setq vc-follow-symlinks t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ido-ignore-files '("^\\."))
 '(org-agenda-files '("~/hw/cs534/project/proposal.org"))
 '(package-selected-packages
   '(lsp-python-ms cypher-mode org-ref powerline hlinum org-bullets xclip lsp-ui which-key lsp-mode solidity-mode matlab-mode jedi-direx py-autopep8 material-theme flycheck elpy ein jedi better-defaults))
 '(safe-local-variable-values
   '((eval setq org-latex-pdf-process
	   '("pdflatex -interaction nonstopmode -output-directory %o %f" "biber %b" "pdflatex -interaction nonstopmode -output-directory %o %f" "pdflatex -interaction nonstopmode -output-directory %o %f"))
     (eval add-hook 'after-save-hook 'org-latex-export-to-pdf t t)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")))
(unless package--initialized (package-initialize))
;; (package-initialize)


(when (not package-archive-contents)
  (package-refresh-contents))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      package-selected-packages)

;; basic customization
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally


;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

   
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


(xclip-mode 1)

;; auto pair
(electric-pair-mode 1)


(windmove-default-keybindings 'ctrl)

(menu-bar-mode -1)
(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)
      (scroll-bar-mode -1))
  (progn
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line)))

;; (tool-bar-mode -1)
;; (toggle-scroll-bar -1)


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
;; (add-hook 'prog-mode-hook 'auto-complete-mode)


(setq initial-scratch-message nil)


(setq auto-save-visited-interval 30)
;; (auto-save-visited-mode 1)
;; (setq auto-save-default t)
(setq auto-save-visited-file-name t)

;; auto refresh all buffers
(global-auto-revert-mode 1)

(setq ac-ignore-case 'smart)


;; LATEX CONFIGURATION
;; --------------------------------------

;; (add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of `latex-mode`
;; (add-to-list 'ac-modes 'LaTeX-mode)   ; make auto-complete aware of `latex-mode`
(add-hook 'LaTeX-mode-hook (lambda ()
	(TeX-fold-mode 1)                             
	(outline-minor-mode 1)
	(add-hook 'find-file-hook 'TeX-fold-buffer)
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
;; (setq ispell-dictionary "english"); Default dictionary. To change do M-x ispell-change-dictionary RET.
;; (add-hook 'text-mode-hook 'flyspell-mode)
;; (add-hook 'prog-mode-hook 'flyspell-prog-mode)
;; (ac-flyspell-workaround) ; fixes a known bug of delay due to flyspell (if it is there)


(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
;; (add-to-list 'ac-modes 'gfm-mode)

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

;; (defun my-delete-line-backward ()
;;   "Delete text between the beginning of the line to the cursor position.
;; This command does not push text to `kill-ring'."
;;   (interactive)
;;   (let (p1 p2)
;;     (setq p1 (point))
;;     (beginning-of-line 1)
;;     (setq p2 (point))
;;     (delete-region p1 p2)))

;; ; bind them to emacs's default shortcut keys:
;; (global-set-key (kbd "C-S-k") 'my-delete-line-backward) ; Ctrl+Shift+k
(global-set-key (kbd "C-k") 'my-delete-line)
(global-set-key (kbd "M-d") 'my-delete-word)
;; Traditionally, Unix uses the ^H keystroke to send a backspace from or to a terminal.
;; swap the <Backspace> and <DEL> keys inside Emacs
;; (keyboard-translate ?\C-h ?\C-?)
(global-set-key (kbd "M-<DEL>") 'my-backward-delete-word)
;; (global-set-key (kbd "[127;5u") 'my-backward-delete-word)


;; solidity 
(require 'solidity-mode)
(setq solidity-comment-style 'slash)
(setq c-basic-offset 4)

;; skip buffer
(require 'ido)
(ido-mode t)
(setq my-unignored-buffers '( "*foo*" "*bar*"))

(defun my-ido-ignore-func (name)
  "Ignore all non-user (a.k.a. *starred*) buffers except those listed in `my-unignored-buffers'."
  (and (string-match "^\*" name)
       (not (member name my-unignored-buffers))))

(setq ido-ignore-buffers '("\\` " my-ido-ignore-func))


(defun my-next-buffer ()
  "next-buffer that skips certain buffers"
  (interactive)
  (next-buffer)
  (while   (and (string-match "^\*" (buffer-name))
       (not (member (buffer-name) my-unignored-buffers)))
    (next-buffer)))

(defun my-previous-buffer ()
  "previous-buffer that skips certain buffers"
  (interactive)
  (previous-buffer)
  (while   (and (string-match "^\*" (buffer-name))
       (not (member (buffer-name) my-unignored-buffers)))
    (previous-buffer)))

(global-set-key [remap next-buffer] 'my-next-buffer)
(global-set-key [remap previous-buffer] 'my-previous-buffer)


;; C/C++ formating


;; (require 'clang-format)
;; (add-hook 'c-mode-common-hook
;;           (function (lambda ()
;;                     (add-hook 'before-save-hook
;;                               'clang-format-buffer))))

;; (add-hook 'c-mode-hook (lambda () (setq comment-start "//"
;;                                         comment-end   "")))

;; (remove-hook 'c-mode-hook 'makefile-gmake-mode)


(require 'powerline)
(powerline-default-theme)


(defun setup-input-decode-map ()
  (define-key input-decode-map "" (kbd "C-S-a"))
  (define-key input-decode-map "[1;5l" (kbd "C-,"))
  (define-key input-decode-map "[1;5p" (kbd "C-0")))
(setup-input-decode-map)
(add-hook 'tty-setup-hook #'setup-input-decode-map)


(global-set-key (kbd "C-S-a") 'mark-whole-buffer)
;; (define-key function-key-map "" 'mark-whole-buffer) ;; [C-S-A]
;; (define-key local-function-key-map "" [C-S-A]) ;; [C-S-A]
;; (global-set-key [C-S-a] 'mark-whole-buffer)
;; (when (display-graphic-p)
;;     (global-set-key (kbd "C-A") 'mark-whole-buffer))
;; ;; (global-set-key (kbd "C-A") 'mark-whole-buffer)
(define-key function-key-map "[25~" 'event-apply-super-modifier) ;; f13
;; (define-key local-function-key-map "\033[32;16~" [(super)])

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(add-hook 'org-mode-hook (lambda () (visual-line-mode 1)))
;; (add-hook 'org-mode-hook (lambda () (flyspell-mode 1)))
(add-hook 'org-mode-hook (lambda () (company-mode 1)))

;; Need to set font for GUI Emacs
;; TODO: add .font to .dotfiles
;; (add-to-list 'default-frame-alist '(font . "DejaVuSansMono Nerd Font"))
;; (set-face-attribute 'default t :font "DejaVuSansMono Nerd Font")

(require 'hlinum)
(hlinum-activate)

;; (global-visual-line-mode t)

(setq default-directory (substring (shell-command-to-string "dirname -z $(mktemp -u)") 0 -1))

(setq org-src-tab-acts-natively t)

(setq lsp-keymap-prefix "s-l")

(require 'lsp-mode)
(require 'lsp-python-ms)
(setq lsp-python-ms-auto-install-server t)
(add-hook 'python-mode-hook #'lsp) ; or lsp-deferred
(add-hook 'python-mode-hook #'yas-minor-mode)
(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)
(add-hook 'lsp-ui-doc-mode-hook (lambda () (setq truncate-lines t)))

(require 'which-key)
(which-key-mode)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

(setq sql-product 'sqlite)
(add-hook 'sql-mode-hook (lambda ()
			   (lsp)
			   (auto-fill-mode 1)
			   (setq-local fill-column 65)))


(require 'org-ref)

(require 'lsp-clangd)
