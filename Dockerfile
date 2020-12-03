FROM iquiw/alpine-emacs
MAINTAINER Lucas Vieira "lucasvieira@protonmail.com"
COPY init.el /root/.emacs.d/
RUN apk --no-cache add graphviz ttf-freefont git
RUN emacs --batch --kill -l /root/.emacs.d/init.el
ENTRYPOINT ["/entrypoint.sh"]
CMD ["emacs"]

