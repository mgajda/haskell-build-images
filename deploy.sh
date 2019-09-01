#!/bin/bash

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

for GHC_VER in 7.8.4 7.10.3 8.0.2 8.2.2 8.4.4 8.6.2; do
  docker push migamake/haskell-build:${GHC_VER};
done;
