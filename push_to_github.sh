#!/usr/bin/env bash
# ============================================================
#  scripts/push_to_github.sh
#  Run this ONCE manually to initialise + push to GitHub.
#  After setup, Jenkins takes over via the Jenkinsfile.
# ============================================================

set -euo pipefail   # Exit on error, unset var, or pipe fail

# ─── CONFIG (edit these before running) ─────────────────────
GITHUB_USERNAME="<YOUR_GITHUB_USERNAME>"
REPO_NAME="spectra-devops-demo"
BRANCH="main"
# Your GitHub Personal Access Token (PAT) with repo scope
# Generate at: https://github.com/settings/tokens
GITHUB_TOKEN="<YOUR_GITHUB_PAT>"
# ────────────────────────────────────────────────────────────

REPO_URL="https://${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "================================================"
echo "  SPECTRA → GitHub Push Script"
echo "================================================"
echo "Project root : $PROJECT_ROOT"
echo "Remote repo  : https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
echo ""

cd "$PROJECT_ROOT"

# ── Step 1: Run Maven build first ───────────────────────────
echo "[1/4] Running Maven build..."
mvn clean package -B -q
echo "      ✅ Maven build complete."

# ── Step 2: Git init (if not already a repo) ────────────────
echo "[2/4] Initialising git repo (if needed)..."
if [ ! -d ".git" ]; then
  git init
  git checkout -b "$BRANCH" 2>/dev/null || git checkout "$BRANCH"
  echo "      ✅ Git initialised."
else
  echo "      ℹ️  Already a git repo — skipping init."
fi

# ── Step 3: Add remote (if not already set) ─────────────────
echo "[3/4] Setting remote origin..."
if git remote get-url origin &>/dev/null; then
  git remote set-url origin "$REPO_URL"
  echo "      ✅ Remote URL updated."
else
  git remote add origin "$REPO_URL"
  echo "      ✅ Remote origin added."
fi

# ── Step 4: Commit and push ──────────────────────────────────
echo "[4/4] Committing and pushing to GitHub..."
git config user.email "devops@spectra.local"
git config user.name  "SPECTRA Bot"
git add -A
git commit -m "feat: initial site deployment 🚀" || echo "      ℹ️  Nothing to commit."
git push -u origin "$BRANCH" --force-with-lease
echo "      ✅ Pushed to https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"

echo ""
echo "================================================"
echo "  🎉 Done! Your site is on GitHub."
echo "  Next: configure Jenkins to use the Jenkinsfile"
echo "================================================"
