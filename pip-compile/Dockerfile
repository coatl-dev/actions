ARG VERSION=3.13
FROM coatldev/python:$VERSION-slim

LABEL \
  maintainer="César Román <cesar@coatl.dev>" \
  repository="https://github.com/coatl-dev/actions/blob/coatl/pip-compile" \
  vendor="coatl.dev"

# https://github.com/jazzband/pip-tools/issues/2176
# hadolint ignore=DL3013,DL3042
RUN set -eux; \
    python -m pip install \
        pip-tools \
        pip<25.1

COPY action.sh /action.sh
RUN chmod +x /action.sh

WORKDIR "/github/workspace"
ENTRYPOINT ["/action.sh"]
