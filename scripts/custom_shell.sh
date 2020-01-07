#!/bin/bash

# その他必要な設定
# docker-compose build時に実行

locale-gen ja_JP.UTF-8
localedef -f UTF-8 -i ja_JP ja_JP

{ \
  echo "source /var/lib/.git-completion.bash"; \
  echo "source /var/lib/.git-prompt.sh"; \
  echo "# git-completion"; \
  echo "export GIT_PS1_SHOWUNTRACKEDFILES=1"; \
  echo "export GIT_PS1_SHOWUPSTREAM='auto'"; \
  echo "export GIT_PS1_SHOWDIRTYSTATE=1"; \
  echo "export GIT_PS1_SHOWCOLORHINTS=true"; \
  echo "# bash-prompt"; \
  echo "export PS1='\[\033[0;33m\]\w \[\033[1;32m\]\$(__git_ps1)\[\033[0m\]\n \[\033[1;32m\]$ \[\033[0m\]'"; \
  echo "export LANG=ja_JP.UTF-8"; \
} | tee /root/.bashrc
