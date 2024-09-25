FROM ghcr.io/r-lib/rig/ubuntu as build

WORKDIR /root

# do this first, because it never changes, so it'll sit in the Docker cache
RUN R -q -e 'options(timeout = 60000); download.file("https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.57/quarto-1.5.57-linux-amd64.deb", "quarto.deb")' && \
    apt install -y ./quarto.deb && \
    apt install -y git && \
    rm quarto.deb && \
    apt-get clean

# only copy the DESCRIPTION first, so dependencies are only reinstalled
# if DESCRIPTION changes
COPY DESCRIPTION .

RUN R -q -e 'pak::pkg_install("deps::."); pak::cache_clean(); pak::meta_clean(TRUE)' && \
    apt-get clean

# copy everything, minus the stuff in .dockerignore
COPY . pkg

WORKDIR /root/pkg

# -------------------------------------------------------------------------
FROM build as test

RUN R -q -e 'pak::pkg_install("deps::.", dependencies = TRUE); pak::cache_clean(); pak::meta_clean(TRUE)' && \
    apt-get clean

RUN R -q -e 'testthat::test_local()'

# -------------------------------------------------------------------------
# this will force running the test step
FROM build as runtime
COPY --from=test /tmp/dummy* /tmp/

# -------------------------------------------------------------------------
FROM build AS dev
