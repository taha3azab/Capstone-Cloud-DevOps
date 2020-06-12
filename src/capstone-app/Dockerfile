##### Stage 1
FROM node:14.4.0-alpine as node

LABEL MAINTAINER Taha Azab <azab.taha@gmail.com>

WORKDIR /app
COPY package.json package.json
RUN npm install --silent --no-progress
COPY . .
RUN npm run build -- --prod

##### Stage 2
FROM nginx:alpine
# Clean nginx
RUN rm -rf /usr/share/nginx/html/*
VOLUME /var/cache/nginx
# Copy dist
COPY --from=node /app/dist/capstone-app /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

# Permission
RUN chown root /usr/share/nginx/html/*
RUN chmod 755 /usr/share/nginx/html/*

# Expose port
EXPOSE 80

# Start
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]

