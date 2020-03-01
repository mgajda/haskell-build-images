# Haskell CI images

This repo contains a script that builds, and pushes images for building projects on CI.

It contains basic tools:
* different compiler version for each tag
* code quality tools:
  - hlint
  - homplexity
* cabal 1.24, since cabal>=2.0 seems to buggy now
* other build tools like stack or pier.

[![Build Status](https://travis-ci.org/mgajda/haskell-build-images.svg?branch=master)](https://travis-ci.org/mgajda/haskell-build-images)
