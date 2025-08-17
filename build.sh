#!/bin/sh

DOCKER_COMPOSE_FILE="docker-compose.prod.yml"

docker-compose -f $DOCKER_COMPOSE_FILE up -d
