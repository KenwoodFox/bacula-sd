
# Base image
FROM debian:12

# Environment variables
ENV BACULA_SD_CONFIG="/etc/bacula/bacula-sd.conf"

# Install bacula-sd
RUN apt-get update && \
    apt-get install -y bacula-sd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create bacula user and group
RUN mkdir -p /etc/bacula /var/lib/bacula /var/log/bacula && \
    chown -R bacula:bacula /etc/bacula /var/lib/bacula /var/log/bacula

# Copy default bacula-sd.conf
COPY bacula-sd.conf /etc/bacula/bacula-sd.conf

# Expose the Bacula-SD default port
EXPOSE 9103

# Bake the git commit into the env
ARG GIT_COMMIT
ENV GIT_COMMIT=$GIT_COMMIT

# Healthcheck
HEALTHCHECK CMD ss -tuln | grep -q ":9103" || exit 1

# Entrypoint to run bacula-sd directly
ENTRYPOINT ["/usr/sbin/bacula-sd", "-f", "-c", "/etc/bacula/bacula-sd.conf"]




