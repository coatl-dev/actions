ARG PYTHON_VERSION=2.7
FROM ghcr.io/coatl-dev/python-tools:${PYTHON_VERSION}-build

LABEL \
  maintainer="César Román <cesar@coatl.dev>" \
  repository="https://github.com/coatl-dev/actions/blob/coatl/pypi-upload" \
  vendor="coatl.dev"

COPY action.sh /action.sh
RUN chmod +x /action.sh

WORKDIR "/github/workspace"
ENTRYPOINT ["/action.sh"]
