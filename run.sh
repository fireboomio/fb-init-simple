#!/usr/bin/env bash

# writen by https://github.com/erguotou520



function get_os_name() {
  if [ "$(uname)" == "Darwin" ]; then
    os_name="mac"
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then   
    os_name="linux"
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then    
    os_name="windows"
  fi
}

get_os_name

function get_os_bin_name() {
  ctl_filename="$1-${os_name}"
  if [ os_name == 'windows' ]; then
    ctl_filename="${ctl_filename}.exe"
  fi
}

function install() {
  type yarn
  if [ $? -eq 0 ]; then
    yarn install
  else
    npm install
  fi
}

function download_wunderctl() {
  get_os_bin_name wunderctl
  bin_url="https://markdown-file-1259215954.cos.ap-nanjing.myqcloud.com/${ctl_filename}"
  curl -o wunderctl $bin_url
  chmod +x wunderctl
  cp wunderctl /usr/local/bin/wunderctl
}

function download_fireboom() {
  get_os_bin_name fireboom
  bin_url="https://fireboom-test.oss-cn-hangzhou.aliyuncs.com/fireboom/bin/${ctl_filename}"
  curl -o fireboom $bin_url
  chmod +x fireboom
}

function download_front() {
  curl -o dist.tar.gz https://fireboom-test.oss-cn-hangzhou.aliyuncs.com/fireboom/front/dist.tar.gz
  rm -rf front
  mkdir -p front
  tar -zxf dist.tar.gz -C front --strip-components 1
  rm -f dist.tar.gz
}

# function install_dep() {
#   cd wundergraph
#   install
#   cd ../
# }

function init() {
  git reset --hard HEAD
  git pull
  # install_dep
  # download_wunderctl
  download_fireboom
  download_front
  ./fireboom
}

function update() {
#   download_wunderctl
  download_fireboom
  download_front
}

function ensure_bin_exist() {
  # type wunderctl
  # if [ ! $? -eq 0 ]; then
  #   download_wunderctl
  # fi
  if [ ! -f "./fireboom" ]; then
    download_fireboom
  fi
  if [ ! -d "./front" ]; then
    download_front
  fi
}

function version() {
  echo "fb version: 0.1"
  # wunderctl version
}

function run() {
  # if [ ! -d "./wundergraph/node_modules" ]; then
  #   install_dep
  # fi
  ensure_bin_exist
  ./fireboom dev
}

case $1 in
  (init)
    init
    ;;
  (update)
    update
    version
    ;;
  (updatefront)
    download_front
    version
    ;;
  (version)
    version
    ;;
  (*)
    run
    ;;
esac