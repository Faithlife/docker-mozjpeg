FROM debian:9 AS builder

RUN apt-get update \
  && apt-get install -y \
    build-essential \
    cmake \
    curl \
    libpng-dev \
    nasm

ENV MOZJPEG_VERSION=d48cfe591f675ec4437505db2dce3ace656a1c6d

WORKDIR /usr/local/src/mozjpeg
RUN curl -LSso mozjpeg.tar.gz https://github.com/mozilla/mozjpeg/archive/${MOZJPEG_VERSION}.tar.gz \
  && tar xf mozjpeg.tar.gz --strip-components=1 \
  && rm mozjpeg.tar.gz
RUN cmake . \
  && make deb

FROM debian:9-slim

COPY --from=builder /usr/local/src/mozjpeg/mozjpeg_4.0.0_amd64.deb /opt/mozjpeg/

RUN dpkg -i /opt/mozjpeg/mozjpeg_4.0.0_amd64.deb
ENV PATH=${PATH}:/opt/mozjpeg/bin
