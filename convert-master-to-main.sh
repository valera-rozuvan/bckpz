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
GIT_REMOTE_NAME="mirror_github"

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
  "to-study"
  "valera-rozuvan"
  "valera-rozuvan-net"
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
  git push --force "${GIT_REMOTE_NAME}" main

  echo "Please change default branch to 'main'. Visit:"
  echo "https://github.com/valera-rozuvan/${repo}/settings/branches"
  while : ; do
    read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] && break
  done

  git fetch "${GIT_REMOTE_NAME}"
  git branch -u "${GIT_REMOTE_NAME}/main" main
  git remote set-head "${GIT_REMOTE_NAME}" -a

  git branch -D master
  git push "${GIT_REMOTE_NAME}" --delete master

  count=$((count+1))
done

echo -e "\nDone!"
exit 0
