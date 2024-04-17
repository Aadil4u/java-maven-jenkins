#!/usr/bin/env bash

export IMAGE=$1
export DOCKER_USR=$2
export DOCKER_PWD=$3

echo $DOCKER_PWD | docker login -u $DOCKER_USR --password-stdin
docker-compose -f docker-compose.yaml up --detach
echo "success"
