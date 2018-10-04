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
    local -r download_dir="${docker_build_dir}"

    local -a versions_a
    IFS=, read -ra versions_a <<< $java_versions

    local java
    for java in "${versions_a[@]}"; do
        java="java_${java}"

        # STAGE 1 - Download
        local java_pkg
        java_pkg=$(java::pkg "${java}" "${download_dir}")
        export docker_build_extra_args="--build-arg JAVA_PKG=${java_pkg}"

        # Stage 2 - Build      
        local docker_image_tag
        docker_image_tag=$(java::docker::tag::full2 "${java}")

        export repo_tag="${registry}/${namespace}/${docker_image_repository}:${docker_image_tag}"

        ./docker-tools/bin/primary-docker-tag.sh

        unset docker_build_extra_args \
            docker_image_tag

        rm -f "${download_dir}/${java_pkg}"
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

