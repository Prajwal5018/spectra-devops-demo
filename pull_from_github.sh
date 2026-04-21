#!/usr/bin/env bash
# ============================================================
#  scripts/pull_from_github.sh
#  Run on your server (or locally) to pull the latest site.
# ============================================================

set -euo pipefail

GITHUB_USERNAME="<YOUR_GITHUB_USERNAME>"
REPO_NAME="spectra-devops-demo"
BRANCH="main"
GITHUB_TOKEN="<YOUR_GITHUB_PAT>"

DEPLOY_DIR="/var/www/html/spectra"   # change to your web root if needed
REPO_URL="https://${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

echo "================================================"
echo "  SPECTRA → GitHub Pull (Deploy) Script"
echo "================================================"

if [ -d "$DEPLOY_DIR/.git" ]; then
  echo "▶ Pulling latest changes..."
  cd "$DEPLOY_DIR"
  git fetch origin
  git reset --hard "origin/${BRANCH}"
  echo "✅ Site updated at $DEPLOY_DIR"
else
  echo "▶ First-time clone into $DEPLOY_DIR..."
  mkdir -p "$DEPLOY_DIR"
  git clone --branch "$BRANCH" "$REPO_URL" "$DEPLOY_DIR"
  echo "✅ Site cloned to $DEPLOY_DIR"
fi

echo ""
echo "Files deployed:"
ls -lh "${DEPLOY_DIR}/src/" 2>/dev/null || ls -lh "$DEPLOY_DIR/"
echo "================================================"
