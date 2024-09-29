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

FROM alpine-emacs
RUN apk --no-cache add graphviz ttf-freefont git rsync \
    build-base g++ gcc automake autoconf libpng-dev \
    glib-dev poppler-dev texlive
COPY --from=bibtex2html /bibtex2html/bibtex2html /usr/bin/bibtex2html
COPY --from=bibtex2html /bibtex2html/bib2bib /usr/bin/bib2bib
COPY init.el /root/.emacs.d/
RUN emacs --batch --kill -l /root/.emacs.d/init.el
RUN mkdir -p /github/home && ln -s /root/.emacs.d /github/home/
ENTRYPOINT ["/entrypoint.sh"]
CMD ["emacs"]

