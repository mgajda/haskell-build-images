#!/bin/bash

GHC_VER="${1:-8.6.5}"
echo "***** Building ${GHC_VER}";
time nice docker build . -f Dockerfile --build-arg "GHC_VER=${GHC_VER}" --tag "migamake/haskell-build:${GHC_VER}"
