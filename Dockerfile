FROM iquiw/alpine-emacs
MAINTAINER Lucas Vieira "lucasvieira@protonmail.com"
COPY init.el /root/.emacs.d/
RUN emacs --batch --kill -l /root/.emacs.d/init.el
ENTRYPOINT ["bash"]
CMD ["emacs"]

