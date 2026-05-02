#!/usr/bin/env bash
set -euo pipefail

SKIP_BUILD=0
if [[ "${1:-}" == "--skip-build" ]]; then
  SKIP_BUILD=1
fi

PORT="${A11Y_PORT:-8080}"
HOST="127.0.0.1"
BASE_URL="http://${HOST}:${PORT}"
A11Y_BROWSER="${A11Y_BROWSER:-chrome}"
A11Y_CHROME_OPTIONS="${A11Y_CHROME_OPTIONS:-no-sandbox,disable-setuid-sandbox,disable-dev-shm-usage}"
PAGES=(
  "${BASE_URL}/"
  "${BASE_URL}/work/"
  "${BASE_URL}/projects/"
  "${BASE_URL}/blog/"
)

if [[ "${SKIP_BUILD}" -eq 0 ]]; then
  npm run build
fi

BROWSER_ARGS=()
SHIM_DIR=""
if [[ "${A11Y_BROWSER}" == "chrome" ]]; then
  if [[ -z "${CHROME_PATH:-}" ]]; then
    for candidate in google-chrome google-chrome-stable chromium chromium-browser com.google.Chrome; do
      if command -v "${candidate}" >/dev/null 2>&1; then
        CHROME_PATH="$(command -v "${candidate}")"
        break
      fi
    done
  fi

  if [[ -z "${CHROME_PATH:-}" ]] && [[ -x "/var/lib/flatpak/exports/bin/com.google.Chrome" ]]; then
    CHROME_PATH="/var/lib/flatpak/exports/bin/com.google.Chrome"
  fi

  if [[ -z "${CHROME_PATH:-}" ]]; then
    echo "Accessibility check failed: Chrome/Chromium not found. Set CHROME_PATH." >&2
    exit 1
  fi

  BROWSER_ARGS=(--chrome-path "${CHROME_PATH}" --chrome-options "${A11Y_CHROME_OPTIONS}")
elif [[ "${A11Y_BROWSER}" == "firefox" ]]; then
  if ! command -v firefox >/dev/null 2>&1; then
    if [[ -x "/var/lib/flatpak/app/org.mozilla.firefox/current/active/files/lib/firefox/firefox" ]]; then
      SHIM_DIR="$(mktemp -d /tmp/axe-firefox-XXXXXX)"
      cat > "${SHIM_DIR}/firefox" <<'EOF'
#!/usr/bin/env bash
exec /var/lib/flatpak/app/org.mozilla.firefox/current/active/files/lib/firefox/firefox "$@"
EOF
      chmod +x "${SHIM_DIR}/firefox"
      export PATH="${SHIM_DIR}:${PATH}"
    elif [[ -x "/var/lib/flatpak/exports/bin/org.mozilla.firefox" ]]; then
      SHIM_DIR="$(mktemp -d /tmp/axe-firefox-XXXXXX)"
      cat > "${SHIM_DIR}/firefox" <<'EOF'
#!/usr/bin/env bash
exec /var/lib/flatpak/exports/bin/org.mozilla.firefox "$@"
EOF
      chmod +x "${SHIM_DIR}/firefox"
      export PATH="${SHIM_DIR}:${PATH}"
    else
      echo "Accessibility check failed: Firefox not found on PATH." >&2
      exit 1
    fi
  fi

  export MOZ_HEADLESS=1
  BROWSER_ARGS=(--browser firefox)
else
  echo "Accessibility check failed: unsupported A11Y_BROWSER '${A11Y_BROWSER}'." >&2
  exit 1
fi

python3 -m http.server "${PORT}" --bind "${HOST}" --directory _site >/tmp/a11y-http-server.log 2>&1 &
SERVER_PID=$!

cleanup() {
  kill "${SERVER_PID}" >/dev/null 2>&1 || true
  wait "${SERVER_PID}" 2>/dev/null || true
  if [[ -n "${SHIM_DIR}" ]]; then
    rm -rf "${SHIM_DIR}"
  fi
}
trap cleanup EXIT INT TERM

READY=0
for _ in {1..20}; do
  if curl --silent --show-error --fail "${BASE_URL}/" >/dev/null; then
    READY=1
    break
  fi
  sleep 0.5
done

if [[ "${READY}" -ne 1 ]]; then
  echo "Accessibility check failed: local server did not start at ${BASE_URL}" >&2
  exit 1
fi

npx -y @axe-core/cli "${PAGES[@]}" \
  "${BROWSER_ARGS[@]}" \
  --exit
