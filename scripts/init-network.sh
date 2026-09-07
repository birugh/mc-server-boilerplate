#!/usr/bin/env bash

set -e

NETWORK_NAME="mc-monitoring"

if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "Docker network '$NETWORK_NAME' already exists."
else
    docker network create \
        --driver bridge \
        "$NETWORK_NAME"

    echo "Docker network '$NETWORK_NAME' created."
fi