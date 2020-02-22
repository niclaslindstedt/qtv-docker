FROM ubuntu:18.04 as build
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /build
RUN apt-get update && apt-get install -y gcc git libc6-dev make gettext
RUN git clone https://github.com/deurk/qtv.git && cd qtv && make

FROM ubuntu:18.04 as run
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /qtv
RUN apt-get update && apt-get install -y gettext \
  && rm -rf /var/lib/apt/lists/*
COPY --from=build /build/qtv/qtv.bin ./qtv.bin
COPY files .
COPY scripts/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
