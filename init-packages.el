;;; Minimal init for package installation phase
;;; This file is ONLY used during Docker build to download packages

(require 'package)

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

;; Minimal settings - no package loading
(setq tab-width 4
      inhibit-startup-screen t
      inhibit-splash-screen t)

;; Create lisp directory
(make-directory "/root/.emacs.d/lisp" t)