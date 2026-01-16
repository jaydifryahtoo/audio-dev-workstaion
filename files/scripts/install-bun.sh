#!/usr/bin/env bash
set -euo pipefail

# Pin Bun for reproducibility (override via BlueBuild module env if desired)
BUN_VERSION="${BUN_VERSION:-bun-v1.3.6}"

# System install locations
BUN_PREFIX="/usr/lib/bun"
BUN_BIN="${BUN_PREFIX}/bun"

# Writable global install locations (Atomic-friendly)
GLOBAL_DIR="/var/lib/bun/install/global"
GLOBAL_BIN="/usr/local/bin"   # On Atomic: /usr/local -> /var/usrlocal

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

arch="$(uname -m)"
case "${arch}" in
  x86_64) bun_target="linux-x64" ;;
  aarch64) bun_target="linux-aarch64" ;;
  *)
    echo "Unsupported architecture: ${arch}"
    exit 1
    ;;
esac

zip_url="https://github.com/oven-sh/bun/releases/download/${BUN_VERSION}/bun-${bun_target}.zip"

echo "==> Installing Bun ${BUN_VERSION} (${bun_target})"
echo "==> Downloading ${zip_url}"
curl --fail --location --silent --show-error \
  --output "${TMPDIR}/bun.zip" \
  "${zip_url}"

echo "==> Extracting"
unzip -q "${TMPDIR}/bun.zip" -d "${TMPDIR}"

# Bun release zips typically contain: bun-<target>/bun
bun_extracted="$(find "${TMPDIR}" -maxdepth 3 -type f -name bun -perm -u+x | head -n 1)"
if [[ -z "${bun_extracted}" ]]; then
  echo "ERROR: bun binary not found after extraction"
  find "${TMPDIR}" -maxdepth 3 -type f -print
  exit 1
fi

echo "==> Installing to ${BUN_BIN}"
install -d -m 0755 "${BUN_PREFIX}"
install -m 0755 "${bun_extracted}" "${BUN_BIN}"

echo "==> Creating CLI entrypoints"
ln -sf "../lib/bun/bun" "/usr/bin/bun"
# bunx works as argv[0] alias; using symlink is the simplest.
ln -sf "bun" "/usr/bin/bunx"

echo "==> Preparing writable global dirs"
install -d -m 0755 "${GLOBAL_DIR}"
install -d -m 0755 "${GLOBAL_BIN}"

echo "==> Seeding per-user defaults via /etc/skel (.bunfig.toml)"
install -d -m 0755 /etc/skel/.config

cat > /etc/skel/.bunfig.toml <<EOF
[install]
globalDir = "${GLOBAL_DIR}"
globalBinDir = "${GLOBAL_BIN}"
EOF

# Also seed XDG config location variant
cp -f /etc/skel/.bunfig.toml /etc/skel/.config/.bunfig.toml

echo "==> Bun installed:"
/usr/bin/bun --version
