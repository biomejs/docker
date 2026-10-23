ARG ALPINE_VERSION=3.23@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659
ARG DEBIAN_VERSION=bookworm-slim
ARG DISTROLESS_BASE=gcr.io/distroless/base-debian12:latest
ARG ARCH="x64"
ARG BIOME_VERSION=2.2.6
ARG BIOME_TAG_START="@biomejs/biome@"
ARG BIOME_RELEASE_BASE_URL="https://github.com/biomejs/biome/releases/download"

# ============================================================================
# Biome glibc binary and runtime libraries for Debian and distroless
# ============================================================================

FROM debian:${DEBIAN_VERSION} AS biome-glibc

ARG ARCH
ARG BIOME_VERSION
ARG BIOME_TAG_START
ARG BIOME_RELEASE_BASE_URL

ADD ${BIOME_RELEASE_BASE_URL}/${BIOME_TAG_START}${BIOME_VERSION}/biome-linux-${ARCH} /usr/local/bin/biome

RUN chmod +x /usr/local/bin/biome \
	&& mkdir -p /runtime-libs \
	&& ldd /usr/local/bin/biome \
		| awk '/=>/ { print $3 } /^\// { print $1 }' \
		| sort -u \
		| xargs -r -I '{}' cp --parents -L '{}' /runtime-libs

# ============================================================================
# Biome musl binary for Alpine
# ============================================================================

FROM alpine:${ALPINE_VERSION} AS biome-musl

ARG ARCH
ARG BIOME_VERSION
ARG BIOME_TAG_START
ARG BIOME_RELEASE_BASE_URL

ADD ${BIOME_RELEASE_BASE_URL}/${BIOME_TAG_START}${BIOME_VERSION}/biome-linux-${ARCH}-musl /usr/local/bin/biome

RUN chmod +x /usr/local/bin/biome

# ============================================================================
# Shared git safe.directory configuration
# ============================================================================

FROM debian:${DEBIAN_VERSION} AS git-config

ARG SAFE_DIRECTORY="/code"

RUN printf '[safe]\n\tdirectory = %s\n' "${SAFE_DIRECTORY}" > /etc/gitconfig

# ============================================================================
# Git runtime bundle for the distroless image
# ============================================================================

FROM debian:${DEBIAN_VERSION} AS git-distroless

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates git \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=git-config /etc/gitconfig /etc/gitconfig

RUN mkdir -p /distroless-git \
	&& cp --parents /usr/bin/git /distroless-git \
	&& cp -a --parents /usr/lib/git-core /distroless-git \
	&& cp -a --parents /usr/share/git-core /distroless-git \
	&& cp -a --parents /etc/gitconfig /distroless-git \
	&& cp -a --parents /etc/ssl/certs /distroless-git \
	&& { \
		ldd /usr/bin/git; \
		find /usr/lib/git-core -type f -executable -exec sh -c 'for file do ldd "$file" 2>/dev/null || true; done' sh '{}' +; \
	} \
		| awk '/=>/ { print $3 } /^\// { print $1 }' \
		| sort -u \
		| xargs -r -I '{}' cp --parents -L '{}' /distroless-git

# ============================================================================
# Alpine variant
# ============================================================================

FROM alpine:${ALPINE_VERSION} AS alpine

RUN apk add --no-cache ca-certificates git

COPY --from=biome-musl /usr/local/bin/biome /usr/local/bin/biome
COPY --from=git-config /etc/gitconfig /etc/gitconfig

ENV GIT_PAGER=cat

WORKDIR /code

ENTRYPOINT ["/usr/local/bin/biome"]

# ============================================================================
# Debian variant
# ============================================================================

FROM debian:${DEBIAN_VERSION} AS debian

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates git \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=biome-glibc /usr/local/bin/biome /usr/local/bin/biome
COPY --from=git-config /etc/gitconfig /etc/gitconfig

ENV GIT_PAGER=cat

WORKDIR /code

ENTRYPOINT ["/usr/local/bin/biome"]

# ============================================================================
# Distroless default variant
# ============================================================================

FROM ${DISTROLESS_BASE} AS distroless

COPY --from=biome-glibc /usr/local/bin/biome /usr/local/bin/biome
COPY --from=biome-glibc /runtime-libs/ /
COPY --from=git-distroless /distroless-git/ /

ENV GIT_PAGER=cat

WORKDIR /code

ENTRYPOINT ["/usr/local/bin/biome"]
