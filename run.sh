#!/bin/bash

set -e
set -o errexit
set -o pipefail

SCRIPT_DIR=$(dirname $(realpath "$0"))
# clone the NDK repo to this dir
# https://github.com/nokia/srlinux-ndk-protobufs
NDK_REPO_DIR=~/nokia/srlinux-ndk-protobufs/

# container image with protoc and protoc-gen-doc
IMAGE_NAME=ghcr.io/srl-labs/protoc
IMAGE_TAG=24.4__1.31.0

# import path ".:/usr/include" includes the current working dir (/in) and the installed protobuf .proto files that reside in /usr/include
PROTOC_GENDOC_CMD='protoc -I /in --doc_opt=json,proto-doc.json --doc_out=/out'

# list of service files to generate docs for
# these services only require import of sdk_common.proto
# it excludes the sdk_service.proto since this service requires import of all other services
# and is handled separately
SERVICE_FILES=(
	"appid_service.proto"
	"bfd_service.proto"
	"config_service.proto"
	"interface_service.proto"
	"lldp_service.proto"
	"mpls_service.proto"
	"networkinstance_service.proto"
	"nexthop_group_service.proto"
	"route_service.proto"
	"telemetry_service.proto"
	"sdk_service.proto"
)

# format the run.sh file
sudo docker run --rm -v "$(pwd):/mnt" -w /mnt mvdan/shfmt:latest -l -w run.sh >/dev/null

function gen-doc {
	if [ -z "$1" ]; then
		echo "Usage: ./run.sh gen-doc <ndk version>"
		echo "  where version is like: v0.2.0"
		exit 1
	fi

	git_ref="$1"
	echo "checking out NDK repo to git ref: ${git_ref}"
	cd ${NDK_REPO_DIR} && git checkout main && git fetch && git checkout ${git_ref}
	# go back to script dir
	cd ${SCRIPT_DIR}

	for SERVICE_FILE in "${SERVICE_FILES[@]}"; do
		generate_doc "${SERVICE_FILE}" "$1"
	done
}

function generate_doc {
	SERVICE_FILE=$1
	SERVICE_NAME=$(basename ${SERVICE_FILE} _service.proto)
	OUT_DIR=$(pwd)/static/ndk-services/${SERVICE_NAME}/$2
	mkdir -p ${OUT_DIR}

	DOCKER_CMD="docker run \
        -v ${OUT_DIR}:/out \
        -v ${NDK_REPO_DIR}/ndk:/in/ndk \
        ${IMAGE_NAME}:${IMAGE_TAG}"

	# imports used by all services but sdk_service.proto
	IMPORTS="/in/ndk/${SERVICE_FILE} /in/ndk/sdk_common.proto"

	# the sdk service requires import of all other services
	if [ "$SERVICE_NAME" == "sdk" ]; then
		IMPORTS="/in/ndk/sdk_service.proto \
                /in/ndk/sdk_common.proto \
                /in/ndk/appid_service.proto \
                /in/ndk/bfd_service.proto \
                /in/ndk/config_service.proto \
                /in/ndk/interface_service.proto \
                /in/ndk/lldp_service.proto \
                /in/ndk/networkinstance_service.proto \
                /in/ndk/nexthop_group_service.proto \
                /in/ndk/route_service.proto"
	fi

	${DOCKER_CMD} ash -c "${PROTOC_GENDOC_CMD} \
    ${IMPORTS}"

	echo "finished Doc compilation for ${SERVICE_FILE}"
}

function help {
	printf "%s <task> [args]\n\nTasks:\n" "${0}"

	compgen -A function | grep -v "^_" | cat -n

	printf "\nExtended help:\n  Each task has comments for general usage\n"
}

# This idea is heavily inspired by: https://github.com/adriancooney/Taskfile
TIMEFORMAT=$'\nTask completed in %3lR'
time "${@:-help}"
