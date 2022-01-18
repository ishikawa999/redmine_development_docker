#!/bin/bash

# read environment variable from .env file
source .env

if [ ! -d app ]; then
  if [ ! `which git` ]; then
      echo -n "git: command not found. "
      # Debian
      [ `which apt` ] && read -p "install [y/N]? " && [ ! x${REPLY^} == xY ] && exit 1 || sudo apt-get update && sudo apt-get install git
      # Alpine
      [ `which apk` ] && read -p "install [y/N]? " && [ ! x${REPLY^} == xY ] && exit 1 || sudo apk add git
  fi
  git clone --config=core.autocflf=input https://github.com/redmine/redmine.git app
  cp overwrite_files/Gemfile.local app/Gemfile.local
  cp overwrite_files/database.yml app/config/database.yml
  cp overwrite_files/configuration.yml app/config/configuration.yml
  cp overwrite_files/additional_environment.rb app/config/additional_environment.rb
  cp -r overwrite_files/.vscode app/.vscode
  echo 'appディレクトリにRedmineリポジトリをcloneしました'
fi

# Update devcontainer
# sed -i s/8000/${APP_PORT}/ .devcontainer/devcontainer.json  # 削除してよい?
sed -i s/Redmine/${APP_NAME}/ .devcontainer/devcontainer.json
echo '.devcontainer/devcontainer.jsonを変更しました'
