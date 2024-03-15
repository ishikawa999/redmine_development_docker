#!/bin/bash

# read environment variable from .env file
source .env

if [ ! -d app ]; then
  if [ ! `which git` ]; then
    read -p "git: command not found.  install [y/N]? "
    [ ! x${REPLY^} == xY ] && exit 1
    [ `which yum` ] && yum install git # RHEL
    [ `which apt` ] && sudo apt-get update && sudo apt-get install git
    [ `which apk` ] && apk add git
  fi
  if [ -z "${REPOSITORY_BRANCH}" ]; then
    git clone --config=core.autocflf=input ${REPOSITORY_URL} app
  else 
    git clone --config=core.autocflf=input -b ${REPOSITORY_BRANCH} ${REPOSITORY_URL} app
  fi
  cp overwrite_files/database.yml app/config/database.yml
  cp overwrite_files/configuration.yml app/config/configuration.yml
  cp overwrite_files/additional_environment.rb app/config/additional_environment.rb
  cp -r overwrite_files/.vscode app/
  echo 'appディレクトリにRedmineリポジトリをcloneしました'
fi

# Update devcontainer
# sed -i s/8000/${APP_PORT}/ .devcontainer/devcontainer.json  # 削除してよい?
sed -i.bak s/Redmine/${APP_NAME}/ .devcontainer/devcontainer.json
echo '.devcontainer/devcontainer.jsonを変更しました'

cp overwrite_files/Gemfile.local app/Gemfile.local