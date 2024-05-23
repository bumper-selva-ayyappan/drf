# by default nginxinc run in root mode which is not recommended thats why the below image
FROM nginxinc/nginx-unprivileged:1-alpine
LABEL maintainer="selva"

COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
COPY ./uwsgi_params /etc/nginx/uwsgi_params
COPY ./run.sh /run.sh

ENV LISTEN_PORT=8000
ENV APP_HOST=app
ENV APP_PORT=9000

# setting root as current user
USER root

RUN mkdir -p /vol/static && \
    chmod 755 /vol/static && \
    # below line creates an empty file, we are creating it just to give read, write permission
    touch /etc/nginx/conf.d/default.conf && \
    chown nginx:nginx /etc/nginx/conf.d/default.conf && \
    # we are giving execute permission on run.sh file
    chmod +x /run.sh

VOLUME /vol/static

# switching user to nginx, we shouldnt not be running the service as root user
USER nginx

CMD ["/run.sh"]
