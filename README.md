# Docker images for Biome

This repository contain the source code for building the official Docker images
for Biome.

Supported architectures: `amd64`, `arm64`

## Supported tags

Docker images are available for all versions of Biome starting from `1.7.0`.

The default image variant is distroless.

Images are tagged with the following formats:

```sh
ghcr.io/biomejs/biome:{major}
ghcr.io/biomejs/biome:{major}.{minor}
ghcr.io/biomejs/biome:{major}.{minor}.{patch}
ghcr.io/biomejs/biome:{major}-alpine
ghcr.io/biomejs/biome:{major}.{minor}-alpine
ghcr.io/biomejs/biome:{major}.{minor}.{patch}-alpine
ghcr.io/biomejs/biome:{major}-debian
ghcr.io/biomejs/biome:{major}.{minor}-debian
ghcr.io/biomejs/biome:{major}.{minor}.{patch}-debian
```

### Examples
- `ghcr.io/biomejs/biome:1`
- `ghcr.io/biomejs/biome:1.9`
- `ghcr.io/biomejs/biome:1.9.4`
- `ghcr.io/biomejs/biome:latest`
- `ghcr.io/biomejs/biome:latest-alpine`
- `ghcr.io/biomejs/biome:latest-debian`
- `ghcr.io/biomejs/biome:1.9.4-alpine`
- `ghcr.io/biomejs/biome:1.9.4-debian`

## Variants

- `distroless` (default): minimal runtime image with no shell or package manager
- `alpine`: Alpine-based image using Biome's musl Linux binaries
- `debian`: Debian-based image using Biome's glibc Linux binaries

All variants include the `git` CLI and ship `/etc/gitconfig` with `/code` marked as a safe directory.

## Usage

The default working directory is set to `/code` in the container.

```sh
# Check files
docker run -v $(pwd):/code ghcr.io/biomejs/biome:1.9.4 check
docker run -v $(pwd):/code ghcr.io/biomejs/biome:1.9.4 check --write

# Lint files
docker run -v $(pwd):/code ghcr.io/biomejs/biome:1.9.4 lint
docker run -v $(pwd):/code ghcr.io/biomejs/biome:1.9.4 lint --write

# Format files
docker run -v $(pwd):/code ghcr.io/biomejs/biome:1.9.4 format
docker run -v $(pwd):/code ghcr.io/biomejs/biome:1.9.4 format --write
```

## License

This project is licensed under the [MIT License](LICENSE.md).
