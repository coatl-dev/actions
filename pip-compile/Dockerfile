ARG VERSION=3.13
FROM coatldev/python:$VERSION-slim

LABEL \
  maintainer="César Román <cesar@coatl.dev>" \
  repository="https://github.com/coatl-dev/actions/blob/coatl/pip-compile" \
  vendor="coatl.dev"

# hadolint ignore=DL3013,DL3042
RUN set -eux; \
    python -m pip install \
        pip-tools

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR "/github/workspace"
ENTRYPOINT ["/entrypoint.sh"]
