FROM alpine:latest

RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
    rsync

ENV VERSION 0.84.0
RUN mkdir -p /usr/local/src \
    && cd /usr/local/src \

    && curl -L \
      https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_linux-64bit.tar.gz \
      | tar -xz \
    && mv hugo /usr/local/bin/hugo \

    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo

WORKDIR /src
COPY orgdocs /src
RUN 'hugo'
CMD ['hugo','server','-w','--bind=0.0.0.0']
EXPOSE 1313
