#!/usr/bin/env bash

function install() {
  type yarn
  if [ $? -eq 0 ]; then
    yarn install
  else
    npm install
  fi
}

function download_wunderctl() {
  curl -o wunderctl https://markdown-file-1259215954.cos.ap-nanjing.myqcloud.com/wunderctl
  chmod +x wunderctl
  cp wunderctl /usr/local/bin/
}

function download_fireboom() {
  curl -o fireboom https://markdown-file-1259215954.cos.ap-nanjing.myqcloud.com/fireboom
  chmod +x fireboom
}

function download_front() {
  curl -o static/dist.tar.gz https://fireboom-test.oss-cn-hangzhou.aliyuncs.com/fireboom/front/dist.tar.gz
  rm -rf static/front
  mkdir -p static/front
  tar -zxf static/dist.tar.gz -C static/front --strip-components 1
  rm -f static/dist.tar.gz
}

function install_dep() {
  cd wundergraph
  install
  cd ../
}

function init() {
  git reset --hard HEAD
  git pull
  install_dep
  download_wunderctl
  download_fireboom
  download_front
  ./fireboom
}

function update() {
  download_wunderctl
  download_fireboom
  download_front
}

function ensure_bin_exist() {
  type wunderctl
  if [ $? -eq 0 ]; then
    :
  else
    download_wunderctl
  fi
  if [ -f "./fireboom" ]; then
    :
  else
    download_fireboom
  fi
  if [ -d "./static/front" ]; then
    :
  else
    download_front
  fi
}

function version() {
  echo "wunderctl version:"
  wunderctl version
}

function run() {
  if [ ! -d "./wundergraph/node_modules" ]; then
    install_dep
  fi
  ensure_bin_exist
  ./fireboom
}

case $1 in
  (init)
    init
    ;;
  (update)
    update
    version
    ;;
  (version)
    version
    ;;
  (*)
    run
    ;;
esac