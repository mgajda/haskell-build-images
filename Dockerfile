FROM    ubuntu:rolling AS haskell-prep
RUN     apt-get update \
     && apt-get upgrade    -y \
     && DEBIAN_FRONTEND=noninteractive \
        apt-get install -y software-properties-common \
                           curl wget alex happy jq \
                           pkg-config netbase git \
                           zlib1g-dev awscli \
                           g++ gcc libc6-dev libffi-dev libgmp-dev make xz-utils zlib1g-dev git gnupg \
                           libc6-pic apt-utils locales netbase happy alex hlint hpack \
                        --no-install-recommends \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists
#                           ruby ruby-bundler \
RUN     add-apt-repository -y ppa:hvr/ghc \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists
RUN     mkdir -p $HOME/.local/bin
ENV     SILENCE_ROOT_WARNING=1
ENV     DEBIAN_FRONTEND=noninteractive
#RUN     mkdir -p       /build/.bundle
#COPY    Dangerfile     /build/Dangerfile
#COPY    .bundle/config /build/.bundle/config
#COPY    Gemfile        /build/Gemfile
#COPY    Gemfile.lock   /build/Gemfile.lock
WORKDIR                /build
# Assortment of build tools
#COPY    pier           /usr/local/bin/pier
#COPY    cabal          /usr/local/bin/cabal
#RUN     bundle install --deployment
#RUN     curl -sSL https://get.haskellstack.org/ | sh
RUN     locale-gen en_SG.UTF-8 en_US.UTF-8
ENV     LC_ALL=en_SG.UTF-8
ENV     LANG=en_SG.UTF-8
RUN     curl -L https://github.com/commercialhaskell/stack/releases/download/v2.1.3/stack-2.1.3-linux-x86_64-static.tar.gz | tar xz --wildcards --strip-components=1 -C /usr/local/bin '*/stack'

FROM haskell-prep AS haskell-tools
COPY stack.yaml /root/.stack/global-project/stack.yaml
RUN  stack install homplexity
RUN  /root/.local/bin/homplexity-cli --version=True .

FROM haskell-prep AS haskell-build
ARG     GHC_VER=8.6.5
ARG     CABAL_VER=2.4
ARG     GHC_LIB=
COPY    --from=haskell-tools /root/.local/bin/homplexity-cli /root/.local/bin/homplexity-cli
# In case you wondered:
ENV     PATH=/root/.local/bin:/root/.cabal/bin:/opt/ghc/$GHC_VER/bin:/opt/cabal/$CABAL_VER/bin:$PATH
#ENV     PATH=/root/.local/bin:/root/.cabal/bin:/opt/ghc/$GHC_VER/bin:$PATH
RUN     apt-get update \
     && apt-get install -y ghc-$GHC_VER ghc-$GHC_VER-dyn ghc-$GHC_VER-prof cabal-install-$CABAL_VER --no-install-recommends \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists
RUN if [ "${GHC_LIB}" != "" ]; then cabal v1-install ghc-lib-${GHC_LIB}; fi
RUN     cabal v1-update \
     && cabal v1-install hspec-discover alex happy hlint hpack --allow-newer
     #&& rm -rf /root/.cabal/packages \
RUN     stack          --version
RUN     ghc            --version
RUN     cabal          --version
#RUN     ruby           --version || true
RUN     hlint          --version
RUN     homplexity-cli --version=True .
ENV     HC=ghc-${GHC_VER}
ENV     HCPKG=ghc-pkg-${GHC_VER}

