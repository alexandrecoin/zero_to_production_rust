#!/usr/bin/env bash
set -x
set -eo pipefail

# Check if a custom parameter has been set, otherwise use default
DB_PORT="${DB_PORT:=5432}"
SUPERUSER="${SUPERUSER:=postgres}"
SUPERUSER_PWD="${SUPERUSER_PWD:=password}"

# Launch PG using Docker
CONTAINER_NAME="zero2prod_postgres"
docker run \
--env POSTGRES_USER=${SUPERUSER} \
--env POSTGRES_PASSWORD=${SUPERUSER_PWD} \
--publish "${DB_PORT}":5432 \
--detach \
--name "${CONTAINER_NAME}" \
postgres -N 1000
