FROM alpine:3.14

RUN apk add --no-cache \
    curl=7.77.0-r1 \
    git=2.32.0-r0 \
    openssh-client=8.6_p1-r2 \
    rsync=3.2.3-r2 

ENV VERSION 0.84.0

# create and set /usr/local/src as folder
WORKDIR /usr/local/src
# set pipefail to make sure that everything fails if one command fails
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN curl -s -L\
      https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-64bit.tar.gz \
      -o hugo_${VERSION}_Linux-64bit.tar.gz \

    && curl -s -L \
      https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_checksums.txt \
      -o hugo_${VERSION}_checksums.txt \
    && cat hugo_${VERSION}_checksums.txt | grep hugo_*_Linux-64bit.tar.gz > checksums.txt \

    && sha256sum -c checksums.txt  2> /dev/null \
    && tar -xzf hugo_${VERSION}_Linux-64bit.tar.gz \

    && mv hugo /usr/local/bin/hugo \
    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 CMD [ 'curl', '-f', 'http://localhost:1313']
WORKDIR /src
COPY orgdocs /src
RUN 'hugo'
CMD ["hugo","server","-w","--bind=0.0.0.0"]
EXPOSE 1313
