FROM ghcr.io/berriai/litellm:main-latest

COPY config.yaml /app/config.yaml

EXPOSE 4000

CMD litellm --config /app/config.yaml --port ${PORT:-4000} --host 0.0.0.0
