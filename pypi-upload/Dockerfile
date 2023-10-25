FROM python:2.7-slim

LABEL \
  maintainer="César Román <cesar@coatl.dev>" \
  repository="https://github.com/coatl-dev/actions/blob/coatl/pypi-upload" \
  vendor="coatl.dev"

ENV PIP_NO_CACHE_DIR 1
ENV PIP_NO_PYTHON_VERSION_WARNING 1

# hadolint ignore=DL3013
RUN set -eux; \
    python -m pip install \
        --upgrade pip setuptools wheel; \
    python -m pip install \
        build \
        twine

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
