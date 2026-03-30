;;; Packages - Optimized for blog export
;;; Only essential packages for HTML/Reveal export

(require 'package)

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

;; Initialize packages (already installed in Docker image)
(package-initialize)
(package-activate-all)

;; Add custom scripts
(add-to-list 'load-path "/root/.emacs.d/lisp/")

;; Use use-package but don't auto-install (packages pre-installed in image)
(require 'use-package)
(setq use-package-always-ensure nil)

;;; Theming - ESSENTIAL for code highlighting in HTML
;; Theme must be loaded BEFORE htmlize for proper fontification
(when (package-installed-p 'kaolin-themes)
  (require 'kaolin-themes nil t)
  (load-theme 'kaolin-aurora t))

;;; HTML export - ESSENTIAL for code highlighting
;; htmlize MUST be loaded before org-html export
(require 'htmlize nil t)
(setq org-html-htmlize-output-type 'css)
(setq org-html-htmlize-fontify-native-code t)

(when (package-installed-p 'highlight-numbers)
  (add-hook 'prog-mode-hook 'highlight-numbers-mode))

;;; General config
(setq tab-width 4
      inhibit-startup-screen t
      inhibit-splash-screen t)

;;; Org config
(when (package-installed-p 'org-contrib)
  (require 'org-contrib))

;; Org-babel languages
(with-eval-after-load 'org
  (mapc (lambda (x)
          (add-to-list 'org-babel-tangle-lang-exts x))
        '(("js"      . "js")
          ("gnu-apl" . "apl"))))

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


;;; Org-reveal - ESSENTIAL for presentations
(when (package-installed-p 'ox-reveal)
  (require 'ox-reveal)
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"
        org-reveal-mathjax t))


;;; Languages - for syntax highlighting in code blocks
(when (package-installed-p 'gnu-apl-mode) (require 'gnu-apl-mode))
(when (package-installed-p 'dyalog-mode) (require 'dyalog-mode))
(when (package-installed-p 'forth-mode) (require 'forth-mode))
(when (package-installed-p 'go-mode) (require 'go-mode))
(when (package-installed-p 'julia-mode) (require 'julia-mode))
(when (package-installed-p 'racket-mode) (require 'racket-mode))
(when (package-installed-p 'clojure-mode) (require 'clojure-mode))
(when (package-installed-p 'rc-mode) (require 'rc-mode))

;; Majestic Mode - for custom syntax
(require 'majestic-mode)

(when (package-installed-p 'rainbow-delimiters)
  (mapc (lambda (hook) (add-hook hook #'rainbow-delimiters-mode))
        '(lisp-mode-hook
          emacs-lisp-mode-hook
          scheme-mode-hook
          clojure-mode-hook
          majestic-mode-hook)))

(mapc (lambda (hook)
        (add-hook hook #'(lambda () (setq indent-tabs-mode nil))))
      '(lisp-mode-hook
        emacs-lisp-mode-hook
        scheme-mode-hook
        clojure-mode-hook
        majestic-mode-hook))

(when (package-installed-p 'unison-mode) (require 'unison-mode))
(when (package-installed-p 'python-mode) (require 'python-mode))
(when (package-installed-p 'purescript-mode) (require 'purescript-mode))
(when (package-installed-p 'reason-mode) (require 'reason-mode))
(when (package-installed-p 'rust-mode) (require 'rust-mode))

(when (package-installed-p 'web-mode)
  (require 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))

(when (package-installed-p 'json-mode) (require 'json-mode))
(when (package-installed-p 'js2-mode) (require 'js2-mode))

(when (package-installed-p 'rjsx-mode)
  (require 'rjsx-mode)
  (add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode)))

(when (package-installed-p 'dockerfile-mode) (require 'dockerfile-mode))

;;; Org-babel
(org-babel-do-load-languages 'org-babel-load-languages
                             '((lisp   . t)
                               (shell  . t)
                               (dot    . t)
                               (js     . t)
                               (C      . t)
                               (scheme . t)))