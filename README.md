# Biome for Docker

This repository contains the Dockerfiles and workflows to build Docker images
for all recent versions of [Biome](https://github.com/biomejs/biome).

Supported architectures: `amd64`, `arm64`

Supported variants: [`debian`](docker/debian.Dockerfile), [`alpine`](docker/alpine.Dockerfile)

## Supported tags

All versions of Biome start from `1.7.0` have Docker images available.

```sh
# Default (bookworm)
ghcr.io/biomejs/biome:{version}

# Variants
ghcr.io/biomejs/biome:{version}-{variant}
```

Where `{variant}` is one of the following: `bookworm`, `bullseye`, `alpine3.20`, `alpine3.19`.

### Examples
- `ghcr.io/biomejs/biome:1`
- `ghcr.io/biomejs/biome:1.9`
- `ghcr.io/biomejs/biome:1.9.2`
- `ghcr.io/biomejs/biome:1-bookworm`
- `ghcr.io/biomejs/biome:1.9-bookworm`
- `ghcr.io/biomejs/biome:1.9.2-bookworm`
- `ghcr.io/biomejs/biome:1-bullseye`
- `ghcr.io/biomejs/biome:1.9-bullseye`
- `ghcr.io/biomejs/biome:1.9.2-bullseye`
- `ghcr.io/biomejs/biome:1-alpine3.19`
- `ghcr.io/biomejs/biome:1.9-alpine3.19`
- `ghcr.io/biomejs/biome:1.9.2-alpine3.19`
- `ghcr.io/biomejs/biome:1-alpine3.20`
- `ghcr.io/biomejs/biome:1.9-alpine3.20`
- `ghcr.io/biomejs/biome:1.9.2-alpine3.20`

## Usage

All images have their entrypoint set to `biome`.

```sh
# Check files
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.2 biome check
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.2 biome check --write

# Lint files
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.2 biome lint
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.2 biome lint --write

# Formatting files
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.2 biome format
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.2 biome format --write
```

## License

This project is licensed under the [MIT License](LICENSE).