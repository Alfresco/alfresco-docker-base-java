#!/bin/bash

set -o errexit

# shellcheck disable=SC2155

declare -r here="$(dirname "${BASH_SOURCE[0]}")"
# shellcheck source=../etc/common.sh
source "${here}/../etc/common.sh"
# shellcheck source=../etc/images.sh
source "${here}/../etc/images.sh"
# shellcheck source=../etc/checksum.sh
source "${here}/../etc/checksum.sh"
# shellcheck source=../lib/java.sh
source "${here}/../lib/java.sh"


main () {
    local -a versions_a
    IFS=, read -ra versions_a <<< $java_versions

    local java
    for java in "${versions_a[@]}"; do
        java="java_${java}"
        # Stage 3 - Relase

        # Get the full tag version-vendor-centos-7 
        local docker_image_tag
        docker_image_tag=$(java::docker::tag::full2 "${java}")

        # Get the short tag (java major version)
        # This variable is used by release-docker-tags.sh
        local DOCKER_IMAGE_TAG_SHORT_NAME
        DOCKER_IMAGE_TAG_SHORT_NAME=$(java::docker::tag::short2 "${java}")

        local private_repo_tag
        private_repo_tag="${registry}/${namespace}/${docker_image_repository}:${docker_image_tag}"
        
        export private_repo_tag
        export DOCKER_IMAGE_TAG_SHORT_NAME

        ./docker-tools/bin/release-docker-tags.sh

        unset docker_image_tag \
            DOCKER_IMAGE_TAG_SHORT_NAME

    done
}

# environment
declare registry
declare namespace
declare java_versions
# From other file
declare docker_image_repository
declare docker_build_dir

export suffix
export docker_build='true'

# Call main() if we're not sourced
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"

