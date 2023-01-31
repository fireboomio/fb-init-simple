#!/usr/bin/env bash

# writen by https://github.com/erguotou520

function get_os_name() {
  if [ "$(uname -s)" == "Darwin" ]; then
    os_name="mac"
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then   
    os_name="linux"
  elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then    
    os_name="windows"
  fi
}

get_os_name
cpu_arch=$(uname -m)

function get_os_bin_name() {
  ctl_filename="$1-${os_name}"
  if [ $os_name == 'windows' ]; then
    if [ $cpu_arch == 'arm64' ]; then
      ctl_filename="${ctl_filename}-${arch}.exe"
    else
      ctl_filename="${ctl_filename}.exe"
    fi
  else
    if [ $cpu_arch == 'arm64' ]; then
      ctl_filename="${ctl_filename}-${cpu_arch}"
    fi
  fi
}

function install() {
  type pnpm >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    pnpm install
  else
    type yarn >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      yarn install
    else
      npm install
    fi
  fi
}

function download_fireboom() {
  get_os_bin_name fireboom
  bin_url="https://fireboom-test.oss-cn-hangzhou.aliyuncs.com/fireboom/bin/${ctl_filename}"
  echo $bin_url
  curl -o fireboom $bin_url
  chmod +x fireboom
}

function install_dep() {
  cd custom-ts
  install
  cd ../
}

function init() {
  git reset --hard HEAD
  git pull
  download_fireboom
  install_dep
  ./fireboom dev
}

function update() {
  download_fireboom
}

function ensure_bin_exist() {
  if [ ! -f "./fireboom" ]; then
    download_fireboom
  fi
}

# function version() {
#   echo "fb version: 0.1"
# }

function run() {
  if [ ! -d "custom-ts/node_modules" ]; then
    install_dep
  fi
  ensure_bin_exist
  ./fireboom dev
}

case $1 in
  (init)
    init
    ;;
  (update)
    update
    # version
    ;;
  # (version)
  #   version
  #   ;;
  (*)
    run
    ;;
esac