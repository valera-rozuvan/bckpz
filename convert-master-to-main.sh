#!/bin/bash

set -o errexit
set -o pipefail

function hndl_SIGHUP() {
  echo "Unfortunately, the script received SIGHUP..."
  exit 1
}
function hndl_SIGINT() {
  echo "Unfortunately, the script received SIGINT..."
  exit 1
}
function hndl_SIGQUIT() {
  echo "Unfortunately, the script received SIGQUIT..."
  exit 1
}
function hndl_SIGABRT() {
  echo "Unfortunately, the script received SIGABRT..."
  exit 1
}
function hndl_SIGTERM() {
  echo "Unfortunately, the script received SIGTERM..."
  exit 1
}

trap hndl_SIGHUP  SIGHUP
trap hndl_SIGINT  SIGINT
trap hndl_SIGQUIT SIGQUIT
trap hndl_SIGABRT SIGABRT
trap hndl_SIGTERM SIGTERM

# ----------------------------------------------------------------------------------------------

LIVE_FOLDER="/home/valera/dev/valera-rozuvan"

# You can get an up to date list using the command:
#
#   ls -ahl /home/valera/dev/valera-rozuvan | tail -n +4 | awk '{print $9}' | sed -e 's/$/\"/g' | sed -e 's/^/  \"/g'
declare -a REPOS=(
  "aws-test-runner"
  "bash-scripts"
  "bckpz"
  "bookmarks-md"
  "cgitrepos"
  "cgit-server-setup"
  "docker-apache2-file-server"
  "docker-cook-scripts"
  "docker-postgres-scripts"
  "dotfiles"
  "dotfiles-emacs"
  "emacs_config"
  "experiments"
  "express-v4-mongodb-starter"
  "fetch-all-github-repos"
  "FractalViewer"
  "gen2fa"
  "howtos"
  "influential-compsci-papers"
  "irc-log-splitter"
  "JSTweener"
  "k-cmake-mode"
  "lambda-math"
  "load-directory-mu"
  "mandelbulb-4d"
  "mdlinkc"
  "mdlinkc-cli"
  "node-postgres-redis-docker-compose"
  "old-sites"
  "orome-emacs"
  "react-webpack-starter"
  "rozuvan-jupyter-notebooks"
  "sharky"
  "sublime_config"
  "text-crypt"
  "text-crypt-cli"
  "valera-rozuvan"
  "valera-rozuvan-net"
  "visual-studio-code-config"
  "web-frameworks-overview"
)

count=1
for repo in "${REPOS[@]}"; do
  echo "[${count} of ${#REPOS[@]}]: '${repo}'"

  LIVE_REPO_PATH="${LIVE_FOLDER}/${repo}"
  cd "${LIVE_REPO_PATH}"
  LIVE_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

  if [[ "$LIVE_BRANCH_NAME" == "main" ]]; then
    count=$((count+1))
    continue
  fi

  if [[ "$LIVE_BRANCH_NAME" == "master" ]]; then
    echo "  -> branch 'master'; will convert"
  else
    echo "  -> ERROR! Expected branch name to be 'master' or 'main'; LIVE_BRANCH_NAME = '${LIVE_BRANCH_NAME}'"
    exit 1
  fi

  git checkout -b main
  git push --force mirror_github main

  echo "Please change default branch to 'main'. Visit:"
  echo "https://github.com/valera-rozuvan/${repo}/settings/branches"
  while : ; do
    read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] && break
  done

  git fetch mirror_github
  git branch -u mirror_github/main main
  git remote set-head mirror_github -a

  git branch -D master
  git push mirror_github --delete master

  count=$((count+1))
done

echo -e "\nDone!"
exit 0
