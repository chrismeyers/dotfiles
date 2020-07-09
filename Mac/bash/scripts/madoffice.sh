#!/usr/bin/env bash

echo "Starting Madoffice Legacy..."
(
  cd ~/.captain/headproxy/madoffice-legacy-development/docker/legacy/development \
    && ./run.development.sh
)

echo "Starting Madoffice API..."
(
  cd ~/.captain/headproxy/madoffice-api-development/docker/api \
    && ./run.development.sh
)

echo "Starting Billing API..."
(
  cd ~/.captain/headproxy/billing-api-development/docker/api \
    && ./run.development.sh
)

docker ps
