# Docker images for Biome

This repository contain the source code for building the official Docker images
for Biome.

Supported architectures: `amd64`, `arm64`

## Supported tags

Docker images are available for all versions of Biome starting from `1.7.0`.

Images are tagged with the following format:

```sh
ghcr.io/biomejs/biome:{major}
ghcr.io/biomejs/biome:{major}{minor}
ghcr.io/biomejs/biome:{major}{minor}{patch}
```

### Examples
- `ghcr.io/biomejs/biome:1`
- `ghcr.io/biomejs/biome:1.9`
- `ghcr.io/biomejs/biome:1.9.4`
- `ghcr.io/biomejs/biome:latest`

## Usage

All images have their entrypoint set to `biome`.

```sh
# Check files
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.4 biome check
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.4 biome check --write

# Lint files
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.4 biome lint
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.4 biome lint --write

# Format files
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.4 biome format
docker run --rm -v $(pwd):/workspace ghcr.io/biomejs/biome:1.9.4 biome format --write
```

## License

This project is licensed under the [MIT License](LICENSE.md).