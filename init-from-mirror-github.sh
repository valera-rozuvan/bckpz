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

GIT_REMOTE_PATH="github:valera-rozuvan"
GIT_REMOTE_NAME="mirror_github"

USER_GPG_KEY="7225457C86D7B6F3"
USER_FULL_NAME="Valera Rozuvan"
USER_EMAIL="valera@rozuvan.net"

mkdir -p "${LIVE_FOLDER}"

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
  if [[ ! -d "${LIVE_REPO_PATH}" ]]; then
    # Step 1.
    echo "  -> cloning from mirror"

    cd "${LIVE_FOLDER}"
    git clone "${GIT_REMOTE_PATH}/${repo}.git" > /dev/null 2>&1
    cd "${LIVE_REPO_PATH}"

    # Step 2.
    echo "  -> add '${GIT_REMOTE_NAME}' remote"

    git remote add "${GIT_REMOTE_NAME}" "${GIT_REMOTE_PATH}/${repo}.git" > /dev/null 2>&1
    git fetch --prune "${GIT_REMOTE_NAME}" > /dev/null 2>&1

    # Step 3.
    echo "  -> switch to '${GIT_REMOTE_NAME}' remote"

    LIVE_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

    git reset --hard "${GIT_REMOTE_NAME}/${LIVE_BRANCH_NAME}" > /dev/null 2>&1
    git clean -f -d > /dev/null 2>&1
    git switch -C "${LIVE_BRANCH_NAME}" "${GIT_REMOTE_NAME}/${LIVE_BRANCH_NAME}" > /dev/null 2>&1

    # Step 4.
    echo "  -> remove 'origin' remote"

    git remote remove origin > /dev/null 2>&1

    # Step 5. Add other mirrors.

    echo "  -> add 'mirror_gitlab' remote"
    git remote add mirror_gitlab "gitlab:valera-rozuvan/${repo}.git" > /dev/null 2>&1

    echo "  -> add 'mirror_backup' remote"
    git remote add mirror_backup "/media/valera/data/valera-rozuvan/${repo}.git" > /dev/null 2>&1

    # Step 6.
    echo "  -> setup commit author details"

    GIT_CONFIG="./.git/config"

    {
      echo "[user]";
      echo "	name = ${USER_FULL_NAME}";
      echo "	email = ${USER_EMAIL}";
      echo "	signingkey = ${USER_GPG_KEY}";
      echo "[gpg]";
      echo "	program = gpg";
      echo "[commit]";
      echo "	gpgsign = true";
    } >> $GIT_CONFIG

    # Step 6. We don't want the remote to rate limit us because of too many requests.
    echo "  -> Sleep 2 seconds."
    sleep 2
  fi

  count=$((count+1))
done

echo -e "\nDone!"
exit 0
