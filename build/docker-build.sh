#!/usr/bin/env bash

# Copyright (c) 2021 Jesse N. <jesse@keplerdev.com>
# This work is licensed under the terms of the MIT license. For a copy, see <https://opensource.org/licenses/MIT>.

image_version= ;
registry= ;
registry_username= ;
registry_password= ;
registry_password_stdin= ;
ghcr_library="jessenich";
ghcr_repository="mssql-server";
library="jessenich91";
repository="mssql-server";
builder="default";
push=false

variant="buster";

show_usage() {
    cat << EOF
Usage: $0 -i [--image-version] x.x.x [FLAGS]
    Flags:
        -h | --help                       - Show this help screen.
        -i | --image-version              - Semantic version compliant string to tag built image with.
        -b | --base-builder-image         - Base Image used to build the OpenWRT firmware.
        -V | --base-builder-image-variant - Base image variant to use"
        -R | --registry                   - Registry that contains the library and repository. Defaults to DockerHub. If either -R or -U are specified, a docker login command will be issued prior to build.
        -U | --registry-username          - Username to login to the specified registry. If either -R or -U are specified, a docker login command will be issued prior to build.
        -P | --registry-password          - Password to login to the specified registry. If either -R or -U are specified, a docker login command will be issued.
        -S | --registry-password-stdin    - Read registry password from the stdin.
        -l | --library                    - The library that contains the repository to push to.
        -r | --repository                 - Repository which the image will be pushed upon successful build. Default value: 'base-alpine'.
        -v | --verbose                    - Print verbose information to stdout.
EOF
}

login() {
    if [ -n "${registry}" ] || [ -n "${registry_username}" ]; then
        login_result=false;

        if [ -z "${registry_password}" ] && [ "${registry_password_stdin}" = false ]; then
            echo "Password required to login to registry '${registry}'";
            exit 2;
        elif [ -n "${registry_password}" ]; then
            login_result="$(docker login \
                --username "${registry_username}" \
                --password "${registry_password}")" >/dev/null;
        elif [ "${registry_password_stdin}" ]; then
            login_result="$(docker login \
                --username "${registry_username}" \
                --password-stdin)" >/dev/null;
        elif [[ "${registry}" = *"acr.azure.com"* ]]; then
            login_result="$(docker login azure; echo $?)" >/dev/null;
        fi

        if [ "${login_result}" != 0 ]; then
            echo "Login to registry '${registry}' failed." 1>&2
            exit 1;
        fi
    fi
}

build() {
    tag1="debian-buster"
    tag2="${image_version}-debian-buster"
    tag3="latest"
    repository_root="."

    echo "Starting build...";
    test -n "$verbose" && \
        echo "  with tag1=$tag1" && \
        echo "       tag2=$tag2" && \
        echo "       tag3=$tag3";

    docker buildx build \
        -f "${repository_root}/Dockerfile" \
        -t "${library}/${repository}:${tag1}" \
        -t "${library}/${repository}:${tag2}" \
        -t "${library}/${repository}:${tag3}" \
        -t "ghcr.io/${ghcr_library}/${ghcr_repository}:${tag1}" \
        -t "ghcr.io/${ghcr_library}/${ghcr_repository}:${tag2}" \
        -t "ghcr.io/${ghcr_library}/${ghcr_repository}:${tag3}" \
        --build-arg "VARIANT=${variant}" \
        --pull \
        --push \
        "${repository_root}"

        echo "Build finished, images oushed to: " && \
            echo "    docker.io/$library/$repository" && \
            echo "    ghcr.io/$ghcr_library/$ghcr_repository"
}

run() {
    login
    build
}

main() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -h | --help)
                show_usage;
                exit 1;
            ;;

            -v | --verbose)
                verbose=true;
                shift;
            ;;

            -i | --image-version)
                image_version="$2";
                shift 2;
            ;;

            -s | --mssql-variant)
                variant="$2";
                shift 2;
            ;;

            -R | --registry)
                registry="$2";
                shift 2;
            ;;

            -U | --registry-username)
                registry_username="$2";
                shift 2;
            ;;

            -P | --registry-password)
                registry_password="$2";
                shift 2;
            ;;

            -S | --registry-password-stdin)
                registry_password_stdin=true;
                shift;
            ;;

            --ghcr-library)
                ghcr_library="$2";
                shift 2;
            ;;

            --ghcr-repository)
                ghcr_repository="$2";
                shift 2;
            ;;

            -l | --library)
                library="$2";
                shift 2;
            ;;

            -r | --repository)
                repository="$2";
                shift 2;
            ;;

            -b | -builder)
                builder="$2";
                shift 2;
            ;;

            -p | --platforms)
                platforms="$2"
                shift 2;
            ;;

            *)
                unbound_arg="$1"
                if [ "${unbound_arg:0:1}" = "v" ]; then
                    # Assume argument is the image version if it beigns with a lowercase v
                    image_version="$1";
                else
                    echo "Invalid option supplied '$1'";
                    show_usage;
                    exit 1;
                fi
                shift
            ;;
        esac
    done
}

main "$@"

## If we've reached this point without a valid --image-version, show usage info and exit with error code.
if [ -z "${image_version}" ]; then
    show_usage;
    exit 1;
fi

run

exit 0;
