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
  "bare-bones-ng6-tour-of-heroes"
  "barebones-react-es5"
  "bash-scripts"
  "bckpz"
  "blender-demos"
  "bookmarks-md"
  "campaigns-manager-ui"
  "cgit-server-setup"
  "cgitrepos"
  "chaos-visualizer"
  "css-glitch-text-image-effects"
  "d3-js-tests"
  "docker-apache2-file-server"
  "docker-cook-scripts"
  "docker-postgres-scripts"
  "dotfiles"
  "dotfiles-emacs"
  "emacs_config"
  "eth-pool-docker-infra"
  "fetch-all-github-repos"
  "FractalViewer"
  "gen2fa"
  "geth-sync-status-orchestrator"
  "gjs-test-examples"
  "howtos"
  "html5-requirejs-jquery-template"
  "influential-compsci-papers"
  "irc-log-splitter"
  "javascript-experiments"
  "js-fiddles"
  "js-patterns"
  "jslife"
  "JSTweener"
  "k-cmake-mode"
  "lambda-math"
  "load-directory-mu"
  "mandelbulb-4d"
  "mdlinkc"
  "mdlinkc-cli"
  "myz-config-parser"
  "ncurses-draw"
  "ng2-es5-test"
  "node-postgres-redis-docker-compose"
  "oep-api-next"
  "old-sites"
  "online-counter"
  "opengl-3-tests"
  "opengl-sample-with-imgui"
  "opengl-tutorials"
  "orome-emacs"
  "react-babel-standalone"
  "react-playground"
  "react-redux-babel-standalone"
  "react-static-playground"
  "react-webpack-starter"
  "rozuvan-jupyter-notebooks"
  "sample-angular-src"
  "sample-postgres-c-code"
  "sharky"
  "shortest_sub_segment"
  "simple-code-demonstrator"
  "simple-express-js-with-db"
  "simple-js-stuff"
  "simple-koa-static-server"
  "simple-node-server"
  "simple-peer-server"
  "simple-webrtc-client-app"
  "stream-video"
  "sublime_config"
  "test-html"
  "text-crypt"
  "text-crypt-cli"
  "three-js-webgl-playground"
  "todomvc-redux-react-v15-typescript"
  "urho3d-demos"
  "valera-rozuvan"
  "valera-rozuvan-net"
  "visual-studio-code-config"
  "web-frameworks-overview"
  "wt-ipfs-docs"
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
