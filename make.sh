#!/usr/bin/env bash

set -eux;

docker build -t silviulucian/docker-lando:latest .

docker push silviulucian/docker-lando:latest
