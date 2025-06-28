FROM ghcr.io/coatl-dev/python-tools:2.7-pip-tools

LABEL \
  maintainer="César Román <cesar@coatl.dev>" \
  repository="https://github.com/coatl-dev/actions/blob/coatl/pip-compile" \
  vendor="coatl.dev"

COPY action.sh /action.sh
RUN chmod +x /action.sh

WORKDIR "/github/workspace"
ENTRYPOINT ["/action.sh"]
