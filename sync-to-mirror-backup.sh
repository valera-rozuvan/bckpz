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

GIT_REMOTE_PATH="/media/valera/data/valera-rozuvan"
GIT_REMOTE_NAME="mirror_backup"

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

  LIVE_REPO_PATH="${LIVE_FOLDER}/${repo}"
  if [[ -d "${LIVE_REPO_PATH}" ]]; then
    cd "${GIT_REMOTE_PATH}/${repo}.git"
    BACKUP_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

    cd "${LIVE_REPO_PATH}"
    LIVE_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

    if [[ "$BACKUP_BRANCH_NAME" == "HEAD" ]]; then
      echo "  -> backup repo empty - this is the first push"
    elif [[ "$BACKUP_BRANCH_NAME" != "$LIVE_BRANCH_NAME" ]]; then
      echo "  -> Error! backup branch '${BACKUP_BRANCH_NAME}' and live branch '${LIVE_BRANCH_NAME}' name mismatch! Please fix."
      exit 1
    fi

    UP_TO_DATE=$({ git push "${GIT_REMOTE_NAME}" "${LIVE_BRANCH_NAME}" 1>&2; } 2>&1 | grep -i "Everything up-to-date" || true)

    if [[ -z "$UP_TO_DATE" || "$UP_TO_DATE" == " " ]]; then
      echo -e "  -> synced to backup, branch '${LIVE_BRANCH_NAME}'\n"
    fi
  fi

  count=$((count+1))
done

echo -e "\nDone!"
exit 0
