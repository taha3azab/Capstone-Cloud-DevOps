FROM nginx:alpine

LABEL MAINTAINER Taha Azab <azab.taha@gmail.com>
break lint docker
RUN rm -rf /usr/share/nginx/html/*
VOLUME /var/cache/nginx
COPY app/capstone-app  /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

RUN chown root /usr/share/nginx/html/*
RUN chmod 755 /usr/share/nginx/html/*

EXPOSE 80

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]

