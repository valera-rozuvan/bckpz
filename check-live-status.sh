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
  "pgm"
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

  NOT_CLEAN="false"
  LIVE_REPO_PATH="${LIVE_FOLDER}/${repo}"

  if [[ ! -d "${LIVE_REPO_PATH}" ]]; then
    echo "  -> Repo folder missing!"
    NOT_CLEAN="true"
  else
    cd "${LIVE_REPO_PATH}"

    FIRST_GREP=$({ git status 1>&2; } 2>&1 | grep -i "Untracked files:" || true)
    SECOND_GREP=$({ git status 1>&2; } 2>&1 | grep -i "Changes not staged for commit:" || true)
    THIRD_GREP=$({ git status 1>&2; } 2>&1 | grep -i "Changes to be committed:" || true)
    FOURTH_GREP=$({ git status 1>&2; } 2>&1 | grep -i "Your branch is ahead of" || true)

    if [[ -n "$FIRST_GREP" && "$FIRST_GREP" != " " ]]; then
      echo "  -> Untracked files!"
      NOT_CLEAN="true"
    fi
    if [[ -n "$SECOND_GREP" && "$SECOND_GREP" != " " ]]; then
      echo "  -> Changes not staged for commit!"
      NOT_CLEAN="true"
    fi
    if [[ -n "$THIRD_GREP" && "$THIRD_GREP" != " " ]]; then
      echo "  -> Changes to be committed!"
      NOT_CLEAN="true"
    fi
    if [[ -n "$FOURTH_GREP" && "$FOURTH_GREP" != " " ]]; then
      echo "  -> Need to push to mirror!"
      NOT_CLEAN="true"
    fi
  fi

  if [[ "$NOT_CLEAN" == "true" ]]; then
    # nice formatting output - print a new empty line if there are some issues for this repo
    echo ""
  fi

  count=$((count+1))
done

echo -e "\nDone!"
exit 0
