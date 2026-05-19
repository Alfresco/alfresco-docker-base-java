# Copilot Instructions

## Repository Purpose

Single-file Dockerfile repository that produces `alfresco/alfresco-base-java` Docker images — headless JRE images on Rocky Linux 8/9, consumed by downstream Alfresco projects as base images.

## Build Commands

### Build an image locally

```bash
docker build -t alfresco-base-java . \
  --build-arg BASE_IMAGE_NAME=rockylinux/rockylinux \
  --build-arg BASE_IMAGE_TAG=9 \
  --build-arg DISTRIB_MAJOR=9 \
  --build-arg JAVA_MAJOR=21 \
  --build-arg JDIST=jre \
  --no-cache
```

### Test a built image

```bash
# Verify Java version
docker run alfresco-base-java java -version 2>&1 | grep -i 'version "21'

# Verify clean bash login
docker run alfresco-base-java /bin/bash
```

### Lint (pre-commit)

```bash
pre-commit run --all-files
```

## Architecture

The entire build is a **single `Dockerfile`** parameterised by build args. The CI matrix in `.github/workflows/main.yml` drives all flavour combinations:

| Build arg | Purpose |
|---|---|
| `BASE_IMAGE_NAME` | Base OS image (e.g. `rockylinux/rockylinux`) |
| `BASE_IMAGE_TAG` | OS image tag (e.g. `8`, `9`) |
| `DISTRIB_MAJOR` | OS major version, used in DNF EPEL URL |
| `JAVA_MAJOR` | Java major version (11, 17, 21, 25) |
| `JDIST` | Java distribution type (`jre`) |

**Supported matrix** (exclusions enforced in CI):
- Rocky 8: Java 11, 17 (JRE)
- Rocky 9: Java 17, 21, 25 (JRE)

**Java 25 special case:** OpenJDK 25 packages are not available in Rocky Linux repositories, so Rocky 9 / Java 25 builds use Eclipse Temurin from the Adoptium project instead of the DNF package path used by other versions.

## Image Naming Convention

```
<jdist><java_major>-<os_flavor><os_major>
```

Examples: `jre17-rockylinux9`, `jre21-rockylinux9`, `jre11-rockylinux8`

## Tagging Strategy

- **Mutable tags**: `jre17-rockylinux9` — always point to the latest master build; used by consumers who want automatic security updates.
- **Immutable tags**: `jre17-rockylinux9-YYMMDDHHMM` — timestamped snapshots, never overwritten; **mandatory on Quay.io** (Quay does not retain images when a mutable tag is updated).
- **Branch builds** on non-master branches get a `-<branch-name>` suffix and a `quay.expires-after=2w` label.

## Publishing

- **Quay.io** (`quay.io/alfresco/alfresco-base-java`): pushed on every branch build (requires enterprise credentials).
- **Docker Hub** (`alfresco/alfresco-base-java`): pushed on `master` only, with retry logic.
- Multi-arch: `linux/amd64` and `linux/arm64/v8`.

## CI Triggers

The main workflow triggers on:
- Push to `Dockerfile`, `.dockerignore`, or `.github/workflows/main.yml`
- Weekly schedule (Monday 02:12 UTC) for security rebuilds
