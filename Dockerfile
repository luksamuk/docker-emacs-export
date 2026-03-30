FROM alpine AS alpine-emacs
RUN apk update &&\
    apk add --no-cache ca-certificates emacs-nox
COPY init-default.el /root/.emacs.d/init.el
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["emacs"]


FROM alpine AS bibtex2html
WORKDIR /
RUN apk update &&\
    apk --no-cache add ocaml git build-base autoconf
RUN git clone https://github.com/backtracking/bibtex2html && \
    cd bibtex2html && \
    autoconf && \
    ./configure && \
    make

FROM alpine AS majestic-lisp
WORKDIR /
RUN apk update &&\
    apk --no-cache add git
RUN git clone https://github.com/luksamuk/majestic-mode

FROM alpine-emacs AS package-builder
# Pre-download all packages during build
RUN apk --no-cache add git
# Use minimal init for package installation (no package loading)
COPY init-packages.el /root/.emacs.d/init.el
COPY --from=majestic-lisp /majestic-mode/majestic-mode.el /root/.emacs.d/lisp/
# Create packages dir and pre-install everything
RUN emacs --batch -l /root/.emacs.d/init.el \
      --eval "(progn \
        (package-refresh-contents) \
        (package-install 'use-package) \
        (package-install 'kaolin-themes) \
        (package-install 'highlight-numbers) \
        (package-install 'org-contrib) \
        (package-install 'htmlize) \
        (package-install 'ox-reveal) \
        (package-install 'pdf-tools) \
        (package-install 'org-ref) \
        (package-install 'gnu-apl-mode) \
        (package-install 'dyalog-mode) \
        (package-install 'forth-mode) \
        (package-install 'go-mode) \
        (package-install 'julia-mode) \
        (package-install 'racket-mode) \
        (package-install 'clojure-mode) \
        (package-install 'rc-mode) \
        (package-install 'unison-mode) \
        (package-install 'python-mode) \
        (package-install 'purescript-mode) \
        (package-install 'reason-mode) \
        (package-install 'rust-mode) \
        (package-install 'web-mode) \
        (package-install 'json-mode) \
        (package-install 'js2-mode) \
        (package-install 'rjsx-mode) \
        (package-install 'dockerfile-mode) \
        (package-install 'rainbow-delimiters))"

FROM alpine-emacs
RUN apk --no-cache add graphviz ttf-freefont git rsync \
    build-base g++ gcc automake autoconf libpng-dev \
    glib-dev poppler-dev texlive
COPY --from=bibtex2html /bibtex2html/bibtex2html /usr/bin/bibtex2html
COPY --from=bibtex2html /bibtex2html/bib2bib /usr/bin/bib2bib
COPY init.el /root/.emacs.d/
COPY --from=majestic-lisp /majestic-mode/majestic-mode.el /root/.emacs.d/lisp/
COPY --from=package-builder /root/.emacs.d/elpa/ /root/.emacs.d/elpa/
RUN mkdir -p /github/home && ln -s /root/.emacs.d /github/home/
ENTRYPOINT ["/entrypoint.sh"]
CMD ["emacs"]