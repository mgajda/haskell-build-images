#!/bin/bash

source config.sh

build_with( {
  echo "***** Building ${GHC_VER} with Cabal ${CABAL_VER}";
  time nice docker build . -f Dockerfile --build-arg "GHC_VER=${GHC_VER}" --tag "migamake/haskell-build:${GHC_VER}";
}
#echo parallel -j4 ./buildSingle.sh -- "${GHC_VERSIONS[@]}"
for GHC_VER in "${GHC_VERSIONS[@]}"; do
  build_with
  #time nice docker build . -f Dockerfile --build-arg "GHC_VER=${GHC_VER}" --tag "migamake/haskell-build:${GHC_VER}" || exit 1;
  # TODO: try to setup GNU Parallel with this one
done;
