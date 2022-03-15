FROM iquiw/alpine-emacs
MAINTAINER Lucas Vieira "lucasvieira@protonmail.com"
COPY init.el /root/.emacs.d/
RUN apk --no-cache add graphviz ttf-freefont git rsync build-base g++ gcc automake autoconf libpng-dev glib-dev poppler-dev
RUN emacs --batch --kill -l /root/.emacs.d/init.el
RUN mkdir -p /github/home && ln -s /root/.emacs.d /github/home/
ENTRYPOINT ["/entrypoint.sh"]
CMD ["emacs"]

