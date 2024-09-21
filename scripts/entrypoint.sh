#!/bin/bash

cd $APP_HOME
bundle install
rake generate_secret_token

rake db:create
rake db:migrate
rake redmine:plugins:migrate
rake log:clear

/custom_shell.sh

exec "$@"
