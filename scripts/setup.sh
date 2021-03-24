#!/bin/bash

cd $APP_HOME

# git-prompt & git-completion
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O /var/lib/.git-completion.bash
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O /var/lib/.git-prompt.sh

chmod a+x /var/lib/.git-prompt.sh
chmod a+x /var/lib/.git-completion.bash

{ \
  echo "source /var/lib/.git-completion.bash"; \
  echo "source /var/lib/.git-prompt.sh"; \
  echo "# git-completion"; \
  echo "export GIT_PS1_SHOWUNTRACKEDFILES=1"; \
  echo "export GIT_PS1_SHOWUPSTREAM='auto'"; \
  echo "export GIT_PS1_SHOWDIRTYSTATE=1"; \
  echo "export GIT_PS1_SHOWCOLORHINTS=true"; \
  echo "# bash-prompt"; \
  echo "export PS1='\[\033[0;33m\]\w \[\033[1;32m\]\[\033[0m\]\[\033[1;32m\]$ \[\033[0m\]'"; \
  echo "export LANG=ja_JP.UTF-8"; \
} | tee /root/.bashrc

# git 文字化け対処
git config --global core.pager "LESSCHARSET=utf-8 less"

echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
update-locale

locale-gen ja_JP.UTF-8
localedef -f UTF-8 -i ja_JP ja_JP
