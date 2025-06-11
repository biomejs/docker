ARG ALPINE_VERSION=3.20

FROM rust:1.81.0-alpine${ALPINE_VERSION} AS builder

ARG BIOME_VERSION=1.9.2
ENV BIOME_VERSION=${BIOME_VERSION}

WORKDIR /usr/src/biome

# Install build dependencies
RUN apk add --no-cache musl-dev make

# Downloads the tarball for the version of Biome we want to build from GitHub Releases
ADD https://github.com/biomejs/biome/archive/refs/tags/cli/v${BIOME_VERSION}.tar.gz /tmp/biome.tar.gz

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