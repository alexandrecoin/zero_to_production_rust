#!/usr/bin/env bash
set -x
set -eo pipefail

# Check if a custom parameter has been set, otherwise use default
DB_PORT="${DB_PORT:=5432}"
SUPERUSER="${SUPERUSER:=postgres}"
SUPERUSER_PWD="${SUPERUSER_PWD:=password}"
APP_USER="${APP_USER:=app}"
APP_USER_PWD="${APP_USER_PWD:=secret}"
APP_DB_NAME="${APP_DB_NAME:=newsletter}"

# Launch PG using Docker
CONTAINER_NAME="zero2prod_postgres"
docker run \
--env POSTGRES_USER=${SUPERUSER} \
--env POSTGRES_PASSWORD=${SUPERUSER_PWD} \
--publish "${DB_PORT}":5432 \
--detach \
--name "${CONTAINER_NAME}" \
postgres -N 1000

# Create the application user
CREATE_QUERY="CREATE USER ${APP_USER} WITH PASSWORD '${APP_USER_PWD}';"
docker exec -it "${CONTAINER_NAME}" psql -U "${SUPERUSER}" -c "${CREATE_QUERY}"

# Grant DB privileges to the App user
GRANT_QUERY="ALTER USER ${APP_USER} CREATEDB;"
docker exec -it "${CONTAINER_NAME}" psql -U "${SUPERUSER}" -c "${GRANT_QUERY}"