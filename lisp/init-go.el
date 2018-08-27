(use-package go-mode
  :config
  (setenv "GOPATH" "/Users/zac/Developer/go")
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-hook 'go-mode-hook 'flycheck-mode))

(use-package company-go
  :config
  (add-hook 'go-mode-hook
	    (lambda ()
	      (set (make-local-variable 'company-backends) '(company-go))
	      (company-mode))))

(provide 'init-go)
