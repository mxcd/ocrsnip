FROM nginx:latest

COPY ./dist/spa /usr/share/nginx/html

