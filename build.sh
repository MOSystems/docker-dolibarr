#!/bin/bash
set -e
DOCKERFILE_PATH=Dockerfile
DOCKER_REPO='mosystems/dolibarr'
IMAGE_NAME="$DOCKER_REPO:latest"
. ./hooks/build
. ./hooks/push