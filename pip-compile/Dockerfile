ARG VERSION=2.7
FROM python:$VERSION-slim

LABEL \
  maintainer="César Román <cesar@coatl.dev>" \
  repository="https://github.com/coatl-dev/actions/blob/coatl/pip-compile" \
  vendor="coatl.dev"

ENV PIP_NO_CACHE_DIR 1
ENV PIP_NO_PYTHON_VERSION_WARNING 1

# hadolint ignore=DL3013
RUN set -eux; \
    python -m pip install \
        --upgrade pip setuptools wheel; \
    python -m pip install \
        pip-tools

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR "/github/workspace"
ENTRYPOINT ["/entrypoint.sh"]
