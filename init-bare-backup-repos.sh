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
  "bash-scripts"
  "bckpz"
  "bookmarks-md"
  "cgitrepos"
  "docker-recipes"
  "dotfiles"
  "experiments"
  "express-v4-mongodb-starter"
  "FractalViewer"
  "gen2fa"
  "hcloud-ts"
  "howtos"
  "JSTweener"
  "lambda-math"
  "load-directory-mu"
  "mandelbulb-4d"
  "mdlinkc"
  "my-jupyter-notebooks"
  "old-sites"
  "react-webpack-starter"
  "rzvn"
  "sharky"
  "talks"
  "text-crypt"
  "three-js-webpack-starter"
  "to-study"
  "valera-rozuvan"
  "valera-rozuvan-net"
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
