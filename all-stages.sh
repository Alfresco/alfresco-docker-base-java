#!/bin/bash

# suffix=${bamboo.planRepository.branchName} 
# repo_tag=${bamboo.docker.registry.address}/${bamboo.docker.registry.namespace}/${bamboo.inject.DOCKER_IMAGE_REPOSITORY}:${bamboo.inject.DOCKER_IMAGE_TAG}

export suffix
export repo_tag
export docker_build_dir='src'


# STAGE 1 - Download
declare JAVA_PKG
JAVA_PKG=$(./build-prep.sh)
[ -z "${JAVA_PKG}" ] && exit 1
export docker_build_extra_args="--build-arg JAVA_PKG=${JAVA_PKG}"

# Stage 2 - Build
./docker-tools/bin/primary-docker-tag.sh