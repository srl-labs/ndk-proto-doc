#!/bin/bash

set -e
set -o errexit
set -o pipefail

NDK_REPO_DIR=~/nokia/srlinux-ndk-protobufs/

# container image with protoc and protoc-gen-doc
IMAGE_NAME=ghcr.io/srl-labs/protoc
IMAGE_TAG=24.4__1.31.0

# import path ".:/usr/include" includes the current working dir (/in) and the installed protobuf .proto files that reside in /usr/include
PROTOC_GENDOC_CMD='protoc -I /in --doc_opt=json,proto-doc.json --doc_out=/out'

SERVICE_FILE=appid_service.proto

function gen-doc {
    if [ -z "$1" ]; then
        echo "Usage: ./run.sh gen-doc <ndk version>"
        echo "  where version is like: v0.2.0"
        exit 1
    fi

    OUT_DIR=$(pwd)/static/ndk-services/appid/
    mkdir -p ${OUT_DIR}

    git_ref="$1"
    echo "checking out NDK repo to git ref: ${git_ref}"
    cd ${NDK_REPO_DIR} && git checkout main && git fetch && git checkout ${git_ref}

    DOCKER_CMD="docker run \
        -v ${OUT_DIR}:/out \
        -v ${NDK_REPO_DIR}/ndk:/in/ndk \
        ${IMAGE_NAME}:${IMAGE_TAG}"

    ${DOCKER_CMD} ash -c "${PROTOC_GENDOC_CMD} \
        /in/ndk/${SERVICE_FILE} \
        /in/ndk/sdk_common.proto"
    echo "finished Doc compilation for service"
}

function help {
  printf "%s <task> [args]\n\nTasks:\n" "${0}"

  compgen -A function | grep -v "^_" | cat -n

  printf "\nExtended help:\n  Each task has comments for general usage\n"
}

# This idea is heavily inspired by: https://github.com/adriancooney/Taskfile
TIMEFORMAT=$'\nTask completed in %3lR'
time "${@:-help}"