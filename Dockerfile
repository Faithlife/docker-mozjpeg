FROM debian:11 AS builder

RUN apt-get update \
  && apt-get install -y \
    build-essential \
    cmake \
    curl \
    libpng-dev \
    nasm

ENV MOZJPEG_VERSION=4.1.1

WORKDIR /usr/local/src/mozjpeg
RUN curl -LSso mozjpeg.tar.gz https://github.com/mozilla/mozjpeg/archive/refs/tags/v${MOZJPEG_VERSION}.tar.gz \
  && tar xf mozjpeg.tar.gz --strip-components=1 \
  && rm mozjpeg.tar.gz
RUN cmake . \
  && make deb

FROM debian:11-slim

ENV MOZJPEG_VERSION=4.1.1

COPY --from=builder /usr/local/src/mozjpeg/mozjpeg_${MOZJPEG_VERSION}_amd64.deb /opt/mozjpeg/

RUN dpkg -i /opt/mozjpeg/mozjpeg_${MOZJPEG_VERSION}_amd64.deb
ENV PATH=${PATH}:/opt/mozjpeg/bin
