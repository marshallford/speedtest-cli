FROM alpine:3.10.3 AS downloader

ARG VERSION

WORKDIR /tmp
RUN wget https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-$VERSION-$(uname -m)-linux.tgz -O - | tar -xz

FROM gcr.io/distroless/static-debian10:nonroot

ARG CREATED
ARG REVISION
ARG VERSION
ARG IMAGE_NAME

LABEL maintainer="Marshall Ford <inbox@marshallford.me>"

LABEL org.opencontainers.image.created=$CREATED \
      org.opencontainers.image.revision=$REVISION \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.title=$IMAGE_NAME \
      org.opencontainers.image.source="https://github.com/marshallford/speedtest-cli" \
      org.opencontainers.image.url="https://www.speedtest.net/apps/cli"

COPY --from=downloader /tmp/speedtest /

ENTRYPOINT ["/speedtest"]
CMD ["--accept-license", "-f", "json"]
