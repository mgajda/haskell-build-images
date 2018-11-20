FROM    ubuntu:bionic AS haskell-prep
RUN     apt-get update
RUN     apt-get install    -y software-properties-common ruby ruby-bundler
RUN     add-apt-repository -y ppa:hvr/ghc
RUN     apt-get install    -y happy alex cabal-install
RUN     mkdir -p $HOME/.local/bin
ENV     SILENCE_ROOT_WARNING=1
# In case you wondered:
ENV     HOME=/root
ENV     PATH=$HOME/.local/bin:$HOME/.cabal/bin:/opt/ghc/$GHC_VER/bin:/usr/share/rvm/bin:$PATH
RUN     mkdir -p       /build/.bundle
COPY    Dangerfile     /build/Dangerfile
COPY    .bundle/config /build/.bundle/config
COPY    Gemfile        /build/Gemfile
COPY    Gemfile.lock   /build/Gemfile.lock
WORKDIR                /build
RUN     bundle install --deployment

FROM haskell-prep AS haskell-build
ARG     GHC_VER=8.6.2
RUN     apt-get install -y ghc-$GHC_VER
RUN     ghc   --version
RUN     cabal --version
RUN     ruby  --version
RUN     cabal update
RUN     cabal install hlint
RUN     hlint --version
ENV     HC=ghc-${GHC_VER}
ENV     HCPKG=ghc-pkg-${GHC_VER}

