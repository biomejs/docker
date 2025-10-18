ARG ALPINE_VERSION=3.22

FROM rust:1.90.0-alpine${ALPINE_VERSION} AS builder

ARG BIOME_VERSION=2.2.6
ARG BIOME_TAG_START="cli/v"

ENV BIOME_VERSION=${BIOME_VERSION}
ENV BIOME_TAG_START=${BIOME_TAG_START}

WORKDIR /usr/src/biome

# Install build dependencies
RUN apk add --no-cache musl-dev make

# Downloads the tarball for the version of Biome we want to build from GitHub Releases
ADD https://github.com/biomejs/biome/archive/refs/tags/${BIOME_TAG_START}${BIOME_VERSION}.tar.gz /tmp/biome.tar.gz

# Extract the tarball into the working directory
RUN tar -xzvf /tmp/biome.tar.gz -C /usr/src/biome/ --strip-components=1

# Build the biome binary
ENV RUSTFLAGS="-C strip=symbols"
RUN cargo build -p biome_cli --release

FROM alpine:${ALPINE_VERSION} AS biome

COPY --from=builder /usr/src/biome/target/release/biome /usr/local/bin/biome

# Install git and flag to repo safe
RUN apk add --no-cache git
RUN git config --global --add safe.directory /code

WORKDIR /code

ENTRYPOINT [ "/usr/local/bin/biome" ]