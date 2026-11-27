#!/usr/bin/env bash
# Mendaftarkan runner sekali (bila belum terdaftar), lalu menjalankannya.
set -Eeuo pipefail
cd /home/ghrunner/actions-runner

if [[ ! -f .runner ]]; then
  : "${RUNNER_URL:?RUNNER_URL belum diisi di .env}"
  : "${RUNNER_TOKEN:?RUNNER_TOKEN belum diisi di .env}"
  ./config.sh --unattended --replace \
    --url "$RUNNER_URL" \
    --token "$RUNNER_TOKEN" \
    --name "${RUNNER_NAME:-cicd-target}" \
    --labels cicd-target \
    --work _work
fi

# Token registrasi tidak dibutuhkan lagi; jangan sampai terbaca oleh job.
unset RUNNER_TOKEN
exec ./run.sh
