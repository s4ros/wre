#!/bin/bash

set -e

if [[ $(id -u) -ne 0 ]]; then
    echo "Need to be root"
    exit 1
fi

function _check_cmd() {
    eval "$@" &> /dev/null
}

# User with UID:1000 has to exist
_check_cmd id 1000
# Check if docker and docker-compose are installed
_check_cmd docker
_check_cmd docker-compose

mkdir ./tmp &> /dev/null || true
mkdir ./public_html &> /dev/null || true
sudo chown -R 1000:1000 ./tmp
sudo chown -R 1000:1000 ./public_html
