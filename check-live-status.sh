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
