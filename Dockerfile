ARG ALPINE_VERSION=3.22

FROM alpine:${ALPINE_VERSION} AS biome

ARG ARCH="x64"
ARG BIOME_VERSION=2.2.6
ARG BIOME_TAG_START="@biomejs/biome@"

ENV BIOME_VERSION=${BIOME_VERSION}
ENV BIOME_TAG_START=${BIOME_TAG_START}

ADD https://github.com/biomejs/biome/releases/download/${BIOME_TAG_START}${BIOME_VERSION}/biome-linux-${ARCH}-musl /usr/local/bin/biome

# Install git and flag to repo safe
RUN chmod +x /usr/local/bin/biome
RUN apk add --no-cache git
RUN git config --global --add safe.directory /code

WORKDIR /code

ENTRYPOINT [ "/usr/local/bin/biome" ]