#!/usr/bin/env bash

# Starts the services required for Madoffice development
# usage: ./madoffice.sh [build]

[[ $1 == "build" ]] && build=true || build=false

echo "Starting Madoffice Legacy..."
(
  cd ~/.captain/headproxy/madoffice-legacy-development/docker/legacy/development

  if [[ $build == true ]]; then
    ./build.development.sh
  fi

  ./run.development.sh
)

echo "Starting Madoffice API..."
(
  cd ~/.captain/headproxy/madoffice-api-development/docker/api

  if [[ $build == true ]]; then
    ./build.development.sh
  fi

  ./run.development.sh
)

echo "Starting Billing API..."
(
  cd ~/.captain/headproxy/billing-api-development/docker/api

  if [[ $build == true ]]; then
    ./build.development.sh
  fi

  ./run.development.sh
)

docker ps
