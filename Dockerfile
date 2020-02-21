FROM ubuntu:18.04 as build
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /build

# Install prerequisites
RUN apt-get update && apt-get install -y gcc git libc6-dev make gettext

# Build qtv
RUN git clone https://github.com/deurk/qtv.git && cd qtv && make

FROM ubuntu:18.04 as run
ARG DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt-get update && apt-get install -y gettext

WORKDIR /qtv
COPY --from=build /build/qtv/qtv.bin ./qtv.bin
COPY files/qtv.cfg.template ./
COPY scripts/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
