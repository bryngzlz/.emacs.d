(defun zac/edit-emacs-config ()
  "Opens Emacs configuration file."
  (interactive)
  (find-file user-init-file))

(defun zac/new-restclient-buffer ()
  (interactive)
  (switch-to-buffer (generate-new-buffer "restclient"))  
  (restclient-mode))

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c o c") 'zac/edit-emacs-config)
(global-set-key (kbd "C-c o r") 'zac/new-restclient-buffer)
(global-set-key (kbd "C-c o a") 'org-agenda)
(global-set-key (kbd "C-c o s") 'ansi-term)
(global-set-key (kbd "C-\\") 'comment-or-uncomment-region)

;; Move more quickly
(global-set-key (kbd "C-S-n")
                (lambda ()
                  (interactive)
                  (ignore-errors (next-line 5))))

(global-set-key (kbd "C-S-p")
                (lambda ()
                  (interactive)
                  (ignore-errors (previous-line 5))))

(global-set-key (kbd "C-S-f")
                (lambda ()
                  (interactive)
                  (ignore-errors (forward-char 5))))

(global-set-key (kbd "C-S-b")
                (lambda ()
                  (interactive)
                  (ignore-errors (backward-char 5))))

(defun delete-current-buffer-file ()
  "Remove file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (kill-buffer buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

(global-set-key (kbd "C-x C-k") 'delete-current-buffer-file)

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defun copy-current-buffer-file ()
  "Copies file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "Copy to: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (copy-file filename new-name 1)
	  (find-file new-name)
          (message "File '%s' successfully copied to '%s'"
                   name (file-name-nondirectory new-name)))))))

(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)
(global-set-key (kbd "C-x C-y") 'copy-current-buffer-file)

(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (transpose-lines 1))
    (line-move -1)
    (move-to-column col)))


(global-set-key (kbd "<C-S-down>") 'move-line-down)
(global-set-key (kbd "<C-S-up>") 'move-line-up)

(defun open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

(global-set-key (kbd "<C-return>") 'open-line-below)
(global-set-key (kbd "<C-S-return>") 'open-line-above)

(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

(defun zac/insert-js-comment ()
  (interactive)
  (insert "/**\n */")
  (previous-line)
  (web-mode-comment-indent-new-line))

(defun zac/remapper-init ()
  (interactive)
  (let ((api-buffer (generate-new-buffer "api"))
	(react-buffer (generate-new-buffer "react"))
	(remapper-dir "~/Developer/remapper"))
    (async-shell-command (format "cd %s && npm run dev" remapper-dir) api-buffer)
    (async-shell-command (format "cd %s/web && npm start" remapper-dir) react-buffer)
    (dired remapper-dir)
    (delete-other-windows)))

(windmove-default-keybindings)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-O") 'other-frame)

(show-paren-mode 1) ; visualize matching parenthesees
(global-hl-line-mode 1) ; highlight current line
(eldoc-mode 1) ; enable docs in minibuffer
(delete-selection-mode 1)

;; store all backups in a single directory 
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

;; y or n instead of yes-or no
(fset 'yes-or-no-p 'y-or-n-p)

;; no annoying bell!
(setq ring-bell-function 'ignore)

;; when on mac
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta) ; set cmd to meta
  (setq mac-option-modifier nil)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t)) ; configure title bar
  (add-to-list 'default-frame-alist '(ns-appearance . 'nil)))

(provide 'zac-misc)
