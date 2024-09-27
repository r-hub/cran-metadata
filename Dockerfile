# syntax=docker/dockerfile:1.7-labs
FROM ghcr.io/r-lib/rig/ubuntu AS build

# do this first, because it never changes, so it'll sit in the Docker cache
# git helps with actions/checkout, rsync is needed for the deploy action
RUN apt-get update && \
    apt-get install -y git rsync && \
    apt-get clean

# only copy the DESCRIPTION first, so dependencies are only reinstalled
# if DESCRIPTION changes
COPY DESCRIPTION .
RUN R -q -e 'pak::pkg_install("deps::.", lib = .Library); pak::cache_clean(); pak::meta_clean(TRUE)' && \
    apt-get clean && \
    rm DESCRIPTION

# copy everything, except the tests
COPY --exclude=tests . /app
WORKDIR /app

# -------------------------------------------------------------------------
FROM build AS test
RUN R -q -e 'pak::pkg_install("deps::.", dependencies = TRUE)'
COPY tests /app/tests
RUN R -q -e 'testthat::test_local()'

# -------------------------------------------------------------------------
# this will force running the test step
FROM build AS runtime
COPY --from=test /tmp/dummy* /tmp/

# -------------------------------------------------------------------------
FROM build AS dev
