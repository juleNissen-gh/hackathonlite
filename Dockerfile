FROM ghcr.io/berriai/litellm:main-latest

COPY config.yaml /app/config.yaml

EXPOSE 4000

ENTRYPOINT []
CMD ["/bin/sh", "-c", "litellm --config /app/config.yaml --port ${PORT:-4000} --host 0.0.0.0"]
