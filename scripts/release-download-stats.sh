#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

default_repo() {
  if git remote get-url origin &>/dev/null; then
    git remote get-url origin | sed -E 's#^(git@github.com:|https://github.com/)##; s#\.git$##'
  else
    echo "RepubIique/MouseLock"
  fi
}

REPO="${GITHUB_REPO:-$(default_repo)}"
API="https://api.github.com/repos/${REPO}/releases"

fetch_releases() {
  if command -v gh >/dev/null 2>&1; then
    gh api "repos/${REPO}/releases"
    return
  fi

  curl -fsSL \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "${API}"
}

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required to parse release data." >&2
  exit 1
fi

if ! releases="$(fetch_releases 2>&1)"; then
  echo "Failed to fetch releases for ${REPO}." >&2
  echo "${releases}" >&2
  echo "Install GitHub CLI (brew install gh) or check your network." >&2
  exit 1
fi

RELEASES_JSON="$releases" python3 - "${REPO}" <<'PY'
import json
import os
import sys

repo = sys.argv[1]

try:
    releases = json.loads(os.environ["RELEASES_JSON"])
except json.JSONDecodeError as exc:
    print(f"Unexpected API response: {exc}", file=sys.stderr)
    sys.exit(1)

if isinstance(releases, dict) and releases.get("message"):
    print(f"GitHub API error: {releases['message']}", file=sys.stderr)
    sys.exit(1)

if not releases:
    print(f"No releases found for {repo}.")
    print("Publish a release with a .dmg asset to start tracking downloads.")
    sys.exit(0)

rows = []
total = 0
latest_total = 0
latest_tag = releases[0].get("tag_name", "?")

for release in releases:
    tag = release.get("tag_name", "?")
    for asset in release.get("assets") or []:
        count = asset.get("download_count") or 0
        rows.append((tag, asset.get("name", "?"), count))
        total += count
        if tag == latest_tag:
            latest_total += count

name_width = max(len(name) for _, name, _ in rows)
tag_width = max(len(tag) for tag, _, _ in rows)

print(f"Release download stats — {repo}\n")
print(f"{'Tag':<{tag_width}}  {'Asset':<{name_width}}  Downloads")
print(f"{'─' * tag_width}  {'─' * name_width}  {'─' * 9}")

for tag, name, count in rows:
    print(f"{tag:<{tag_width}}  {name:<{name_width}}  {count:,}")

print()
print(f"Total (all releases): {total:,}")
print(f"Latest ({latest_tag}):  {latest_total:,}")
print()
print("README badge (auto-updates on GitHub):")
print(f"  https://img.shields.io/github/downloads/{repo}/total")
PY
