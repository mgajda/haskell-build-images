#!/bin/bash

source config.sh

for GHC_VER in "${GHC_VERSIONS[@]}"; do
  docker build . -f Dockerfile --build-arg "GHC_VER=${GHC_VER}" --tag "migamake/haskell-build:${GHC_VER}" || exit 1;
done;
