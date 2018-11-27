FROM    ubuntu:bionic AS haskell-prep
RUN     apt-get update \
     && apt-get upgrade    -y \
     && apt-get install -y software-properties-common \
                           ruby ruby-bundler \
                           curl wget alex happy jq \
                           pkg-config netbase git \
                        --no-install-recommends \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists
RUN     add-apt-repository -y ppa:hvr/ghc \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists
RUN     mkdir -p $HOME/.local/bin
ENV     SILENCE_ROOT_WARNING=1
# In case you wondered:
ENV     PATH=/root/.local/bin:/root/.cabal/bin:/opt/ghc/$GHC_VER/bin:/usr/share/rvm/bin:$PATH
RUN     mkdir -p       /build/.bundle
COPY    Dangerfile     /build/Dangerfile
COPY    .bundle/config /build/.bundle/config
COPY    Gemfile        /build/Gemfile
COPY    Gemfile.lock   /build/Gemfile.lock
WORKDIR                /build
# Assortment of build tools
COPY    pier           /usr/local/bin/pier
COPY    cabal          /usr/local/bin/cabal
RUN     bundle install --deployment
RUN     curl -L https://github.com/commercialhaskell/stack/releases/download/v1.7.1/stack-1.7.1-linux-x86_64.tar.gz | tar xz --wildcards --strip-components=1 -C /usr/local/bin '*/stack'

FROM haskell-prep AS haskell-build
ARG     GHC_VER=8.6.2
RUN     apt-get update \
     && apt-get install -y ghc-$GHC_VER --no-install-recommends \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists
RUN     cabal update \
     && cabal install hlint homplexity \
     && rm -rf /root/.cabal/packages
RUN     ghc            --version
RUN     cabal          --version
RUN     ruby           --version
RUN     hlint          --version
RUN     homplexity-cli --version || exit 0
ENV     HC=ghc-${GHC_VER}
ENV     HCPKG=ghc-pkg-${GHC_VER}

