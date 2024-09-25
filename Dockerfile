FROM ghcr.io/r-lib/rig/ubuntu AS build

# do this first, because it never changes, so it'll sit in the Docker cache
RUN R -q -e 'options(timeout = 60000); download.file("https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.57/quarto-1.5.57-linux-amd64.deb", "quarto.deb")' && \
    apt install -y ./quarto.deb && \
    rm quarto.deb && \
    apt-get install -y git rsync && \
    apt-get clean

# only copy the DESCRIPTION first, so dependencies are only reinstalled
# if DESCRIPTION changes
COPY DESCRIPTION .
RUN R -q -e 'pak::pkg_install("deps::.", lib = .Library); pak::cache_clean(); pak::meta_clean(TRUE)' && \
    apt-get clean && \
    rm DESCRIPTION

# -------------------------------------------------------------------------
FROM build AS test

COPY DESCRIPTION .
RUN R -q -e 'pak::pkg_install("deps::.", dependencies = TRUE); pak::cache_clean(); pak::meta_clean(TRUE)' && \
    apt-get clean && \
    rm DESCRIPTION

# copy everything, minus the stuff in .dockerignore
COPY . /root/pkg
WORKDIR /root/pkg
RUN R -q -e 'testthat::test_local()'

# -------------------------------------------------------------------------
# this will force running the test step
FROM build AS runtime
COPY --from=test /tmp/dummy* /tmp/

# -------------------------------------------------------------------------
FROM build AS dev
