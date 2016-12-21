#!/bin/sh
set -e

UID=${UID:-0}
GID=${GID:-0}

# If we are running composer, make sure it executes as the specified uid/gid.
if [ "$1" = "composer" ]; then
  su-exec ${UID}:${PWD} "$@"
fi

exec "$@"
