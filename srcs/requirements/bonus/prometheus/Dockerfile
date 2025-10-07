FROM debian:bullseye

# Install only ca-certificates for HTTPS scraping
RUN apt-get update && apt-get install -y ca-certificates curl && rm -rf /var/lib/apt/lists/*

# Set Prometheus version
ENV PROM_VERSION=2.52.0

# Download and extract Prometheus binary
RUN curl -fsSL https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz -o prometheus.tar.gz \
    && mkdir -p /tmp/prometheus \
    && tar -xzf prometheus.tar.gz -C /tmp/prometheus \
    && cp /tmp/prometheus/prometheus-${PROM_VERSION}.linux-amd64/prometheus /usr/local/bin/ \
    && cp /tmp/prometheus/prometheus-${PROM_VERSION}.linux-amd64/promtool /usr/local/bin/ \
    && cp -r /tmp/prometheus/prometheus-${PROM_VERSION}.linux-amd64/consoles /prometheus/ \
    && cp -r /tmp/prometheus/prometheus-${PROM_VERSION}.linux-amd64/console_libraries /prometheus/ \
    && rm -rf /tmp/prometheus prometheus.tar.gz
# Create data directory
RUN mkdir -p /prometheus/data

WORKDIR /prometheus
EXPOSE 9090

# Default command
CMD ["/usr/local/bin/prometheus", "--config.file=/prometheus/prometheus.yml", "--storage.tsdb.path=/prometheus/data"]

