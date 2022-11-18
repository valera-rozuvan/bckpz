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
BACKUP_FOLDER="/media/valera/data/valera-rozuvan"
mkdir -p $BACKUP_FOLDER

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
  "react-webpack-starter"
  "rozuvan-jupyter-notebooks"
  "sharky"
  "text-crypt"
  "text-crypt-cli"
  "valera-rozuvan"
  "valera-rozuvan-net"
  "web-frameworks-overview"
)

count=1
for repo in "${REPOS[@]}"; do
  echo "[${count} of ${#REPOS[@]}]: '${repo}'"

  BACKUP_REPO_PATH="${BACKUP_FOLDER}/${repo}.git"
  if [[ ! -d "${BACKUP_REPO_PATH}" ]]; then
    LIVE_REPO_PATH="${LIVE_FOLDER}/${repo}"
    cd "${LIVE_REPO_PATH}"

    LIVE_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

    echo "  -> creating bare repo"
    git init --bare "${BACKUP_REPO_PATH}" > /dev/null 2>&1

    # note - starting with Git v2.28.0, there is an option --initial-branch=<branch-name>
    # however, current git in Debian stable is old; so we will use another way

    cd "${BACKUP_REPO_PATH}"

    echo -e "  -> setting default branch '${LIVE_BRANCH_NAME}'\n"
    git symbolic-ref HEAD "refs/heads/${LIVE_BRANCH_NAME}" > /dev/null 2>&1
  fi

  count=$((count+1))
done

echo -e "\nDone!"
exit 0
