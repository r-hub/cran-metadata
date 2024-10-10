# syntax=docker/dockerfile:1.7-labs
FROM ghcr.io/r-lib/rig/ubuntu@sha256:1dc2de2cf32dd10945a4ed3714ae35e73b01e1ea47f458c3e9dc82eef016a3e2 AS build

# do this first, because it never changes, so it'll sit in the Docker cache
# git helps with actions/checkout, rsync is needed for the deploy action
RUN apt-get update && \
    apt-get install -y git rsync \
        libcurl4-openssl-dev libssl-dev make libicu-dev libxml2-dev && \
    apt-get clean

RUN mkdir /app
WORKDIR /app

# only copy the DESCRIPTION first, so dependencies are only reinstalled
# if DESCRIPTION changes
COPY renv renv
COPY DESCRIPTION renv.lock .Rprofile .Rbuildignore .
RUN R -q -e 'renv::restore()'

# copy everything, except the tests
COPY --exclude=tests . /app

# -------------------------------------------------------------------------
FROM build AS test

ENV NOT_CRAN=true
COPY test[s] /app/tests

RUN if [ -d /app/tests ]; then \
      R -q -e 'renv::install(dependencies = TRUE)'; \
      R -q -e 'testthat::test_local()'; \
      R -q -e 'covr::to_cobertura(print(covr::package_coverage()))'; \
    fi

ARG GITHUB_SHA
ARG GITHUB_REPOSITORY
ARG GITHUB_REF_NAME
RUN --mount=type=secret,id=CODECOV_TOKEN \
    if [ -d /app/tests ] && [ -f /run/secrets/CODECOV_TOKEN ]; then \
      R -q -e 'download.file("https://cli.codecov.io/latest/linux/codecov", "/usr/local/bin/codecov")' && \
      chmod +x /usr/local/bin/codecov && \
      codecov upload-process --disable-search -f cobertura.xml --plugin noop \
        --git-service github --token `cat /run/secrets/CODECOV_TOKEN` \
        --sha ${GITHUB_SHA} --slug ${GITHUB_REPOSITORY} \
        --branch ${GITHUB_REF_NAME}; \
    fi

# -------------------------------------------------------------------------
# this will force running the test step
FROM build AS runtime
COPY --from=test /tmp/dummy* /tmp/

# -------------------------------------------------------------------------
FROM build AS dev
