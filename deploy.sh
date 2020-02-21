#!/bin/bash

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

source ./config.sh

for GHC_VER in "${GHC_VERSIONS[@]}"; do
  echo "***** Deploying ${GHC_VER}";
  docker push "migamake/haskell-build:${GHC_VER}";
done;
