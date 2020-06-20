FROM node:lts-slim as node

LABEL MAINTAINER Taha Azab <azab.taha@gmail.com>

WORKDIR /app
COPY app/capstone-app/package*.json ./
RUN npm ci --only=production
COPY app/capstone-app .
RUN npm run build -- --prod

FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
VOLUME /var/cache/nginx
COPY --from=node /app/dist/capstone-app /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

RUN chown root /usr/share/nginx/html/*
RUN chmod 755 /usr/share/nginx/html/*

EXPOSE 80

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]

