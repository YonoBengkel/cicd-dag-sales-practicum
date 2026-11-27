# Target deployment berbasis Docker, pengganti VM Ubuntu pada modul (bagian 6 dan 10).
# Isinya Python 3.11 (sama dengan job validate), GitHub Actions self-hosted runner,
# user non-root ghrunner, dan direktori /opt/data-cluster yang hanya bisa ditulis ghrunner.
FROM python:3.11-slim-trixie

ARG RUNNER_VERSION=2.338.2
ARG RUNNER_SHA256=baebf204307bac6193480852732f0aba2ae97b6c5597c244f4d5558390147c40

# curl untuk mengunduh runner; git agar actions/checkout membuat repository git sungguhan.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git \
    && rm -rf /var/lib/apt/lists/*

# User khusus runner: bukan root dan tanpa sudo (least privilege).
RUN useradd --create-home --shell /bin/bash ghrunner

# Runner resmi GitHub, dicocokkan dengan checksum SHA-256 dari halaman rilisnya.
WORKDIR /home/ghrunner/actions-runner
RUN curl -fsSL -o runner.tar.gz \
        "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" \
    && echo "${RUNNER_SHA256}  runner.tar.gz" | sha256sum -c - \
    && tar xzf runner.tar.gz \
    && rm runner.tar.gz \
    && ./bin/installdependencies.sh \
    && rm -rf /var/lib/apt/lists/* \
    && chown -R ghrunner:ghrunner /home/ghrunner

# Direktori deployment: hanya ghrunner yang boleh menulis.
RUN mkdir -p /opt/data-cluster/releases \
    && chown -R ghrunner:ghrunner /opt/data-cluster \
    && chmod 750 /opt/data-cluster

# sed membuang CRLF bila berkas ini tersimpan dengan akhir baris Windows.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh \
    && chmod 755 /usr/local/bin/entrypoint.sh

# RUNNER_MANUALLY_TRAP_SIG: runner berhenti rapi saat container di-stop.
# PYTHONDONTWRITEBYTECODE: uji impor di release tidak menulis __pycache__ ke dalamnya.
ENV RUNNER_MANUALLY_TRAP_SIG=1 \
    PYTHONDONTWRITEBYTECODE=1
USER ghrunner
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
