;;; Packages

(require 'package)

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)


;;; Install use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; el-get
(use-package el-get
  :config (progn
            (remove-hook 'el-get-post-install-hooks
                         'el-get-post-install-notification)
            (remove-hook 'el-get-post-remove-hooks
                         'el-get-post-remove-notification)))

;;; Theming
(use-package kaolin-themes
  :config (load-theme 'kaolin-aurora t))

(use-package highlight-numbers
  :config (add-hook 'prog-mode-hook 'highlight-numbers-mode))

;;; General config
(setq tab-width 4
      inhibit-startup-screen t
      inhibit-splash-screen t)

;;; Org config
(use-package org
  :ensure org-contrib)

(mapc (lambda (x)
        (add-to-list 'org-babel-tangle-lang-exts x))
      '(("js"      . "js")
        ("gnu-apl" . "apl")))

(use-package htmlize
  :config (setq htmlize-output-type 'css))

(setq org-html-html5-fancy t)

(setq org-confirm-babel-evaluate nil)

;;; Org + LaTeX
(require 'ox-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))

(add-to-list 'org-latex-classes
             '("abntex2"
               "\\documentclass{abntex2}
                  [NO-DEFAULT-PACKAGES]
                  [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
               ("\\maketitle" . "\\imprimircapa")))
(add-to-list 'org-latex-classes
             '("standalone"
               "\\documentclass{standalone}
                [NO-DEFAULT-PACKAGES]"))
(setq org-latex-pdf-process '("latexmk -shell-escape -bibtex -f -pdfxe -8bit %f"))
(setq org-latex-listings 'minted)
(add-to-list 'org-latex-minted-langs
             '(lisp "common-lisp"))
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-inputenc-alist '(("utf8" . "utf8x")))
(add-to-list 'org-latex-default-packages-alist
             '("mathletters" "ucs" nil))


;;; Org-reveal
(use-package ox-reveal
  :config (setq org-reveal-root    "https://cdn.jsdelivr.net/npm/reveal.js"
                org-reveal-mathjax t))


;;; Org-ref
(use-package pdf-tools
  :config (pdf-tools-install t))
(use-package org-ref
  :config (progn (require 'org-ref-pdf)
		 (require 'org-ref-bibtex)
                 (require 'org-ref-url-utils)))

;;(org-ref-define-citation-link "citeonline" ?o)
(defconst org-ref-abntex-types
  '("citeonline" "Cite without parens (abnTeX2)"))
(add-to-list 'org-ref-cite-types org-ref-abntex-types)

(require 'ox-bibtex)


;;; Languages
(use-package gnu-apl-mode)
(use-package dyalog-mode)
(use-package forth-mode)
(use-package go-mode)
(use-package julia-mode)
(use-package lean-mode)
(use-package racket-mode)
(use-package shen-mode)
(use-package clojure-mode)
(use-package rc-mode)

(el-get-bundle luksamuk/majestic-mode)
(require 'majestic-mode)

(use-package rainbow-delimiters
  :config (mapc (lambda (hook) (add-hook hook #'rainbow-delimiters-mode))
                '(lisp-mode-hook
                  emacs-lisp-mode-hook
                  scheme-mode-hook
                  shen-mode-hook
                  clojure-mode-hook
                  majestic-mode-hook)))

(mapc (lambda (hook)
        (add-hook hook #'(lambda () (setq indent-tabs-mode nil))))
      '(lisp-mode-hook
        emacs-lisp-mode-hook
        scheme-mode-hook
        shen-mode-hook
        clojure-mode-hook
        majestic-mode-hook))

(use-package unison-mode)
(use-package python-mode)
(use-package purescript-mode)
(use-package reason-mode)
(use-package rust-mode)

(use-package web-mode
  :init (progn
          (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))))
(use-package json-mode)
(use-package js2-mode)
(use-package rjsx-mode
  :config (progn
            (add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
            (add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))))
(use-package dockerfile-mode)

;;; Org-babel
(org-babel-do-load-languages 'org-babel-load-languages
                             '((lisp   . t)
                               (shell  . t)
                               (dot    . t)
                               (js     . t)
                               (C      . t)
                               (scheme . t)))
