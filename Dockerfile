FROM   alpine
EXPOSE 5000 
#ADD    application /
#RUN    chmod +x /application

RUN apk update \
        && apk upgrade \
        && apk add --no-cache \
        ca-certificates \
        && update-ca-certificates 2>/dev/null || true

#CMD    ["/application"]