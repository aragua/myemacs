(add-to-list 'load-path "~/.emacs.d/" t)

;;disable backup
(setq backup-inhibited t)
;;disable auto save
(setq auto-save-default nil)

;; 80 columns
(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))
;;(add-hook 'c-mode-hook 'whitespace-mode)
;; or
(require 'fill-column-indicator)
(setq fci-rule-column 80)
;;(add-hook 'c-mode-hook 'fci-mode)

;; Linux kernel C style
;;(defun linux-c-mode ()
;;  "C mode with adjusted defaults for use with the Linux kernel."
;;  (interactive)	
;;  (c-mode)	
;;  (c-set-style "K&R")
;;  (setq tab-width 8)
;;  (setq indent-tabs-mode t)
;;  (setq c-basic-offset 8)
;;  (setq indent-tabs-mode t)
;;  (setq show-trailing-whitespace t)  
;;  )
;;(add-hook 'c-mode-common-hook 'linux-c-mode)
;;or
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	  (column (c-langelem-2nd-pos c-syntactic-element))
	   (offset (- (1+ column) anchor))
	    (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
                         (string-match (expand-file-name "~/workset/")
                                       filename))
                (setq indent-tabs-mode t)
                (setq show-trailing-whitespace t)
                (c-set-style "linux-tabs-only")))))



;; Ctags
;;    M-. <RET>       - Jump to the tag underneath the cursor
;;    M-. <tag> <RET> - Search for a particular tag
;;    C-u M-.         - Find the next definition for the last tag
;;    M-*             - Pop back to where you previously invoked "M-."
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags -f %s/TAGS -e -R %s " (directory-file-name dir-name) (directory-file-name dir-name) )
   )
  )


;; Bind keys
(global-set-key (kbd "<f1>") 'menu-bar-open)
(global-set-key (kbd "<f2>") 'create-tags)
(global-set-key (kbd "<f3>") 'replace-string)
(global-set-key (kbd "<f4>") 'find-tag)
(global-set-key (kbd "<f5>") 'pop-tag-mark)
(global-set-key (kbd "<f10>") 'linum-mode)
(global-set-key (kbd "<f11>") 'fci-mode)
(global-set-key (kbd "<f12>") 'whitespace-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
