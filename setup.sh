#!/bin/bash -eux
if [ "$(uname)" = "Darwin" ] ; then
  [ -x /usr/local/bin/realpath ] || brew install coreutils
fi

DEST="$( dirname "$0" )"
DEST="$( realpath "$DEST" )"
cd $HOME
ln -sf ${DEST}/bashrc .bashrc
ln -sf ${DEST}/bashrc .profile
ln -sf ${DEST}/vimrc .vimrc
ln -sf ${DEST}/vim-spellfile .vim-spell.en.utf-8.add
ln -sf ${DEST}/gitconfig .gitconfig
ln -sf ${DEST}/git-excludes .git-excludes
ln -sf ${DEST}/tmux.conf .tmux.conf
ln -sf ${DEST}/toprc .toprc
if [ ! -d .config ] ; then mkdir .config ; fi
ln -sf ${DEST}/fish .config/fish
if [ ! -f .ssh/config ] ; then
  # For safety reasons, don't overwrite any existing config
  if [ ! -d .ssh ] ; then
    mkdir -m 0700 .ssh
    restorecon -R -v .ssh 2>/dev/null || true
  fi
  ln -s ${DEST}/ssh-config .ssh/config
fi

if [ ! "${1-}" = "-n" ] ; then
  if [ "$(uname)" = "Darwin" ] ; then
    # Mac
    [ -x /usr/local/bin/tmux ] || brew install tmux
    [ -x /usr/local/bin/fish ] || brew install fish
    [ -d ${HOME}/.local/share/omf ] || curl -L https://get.oh-my.fish | fish
    fish -c 'omf install bobthefish'
    if [ ! -f ${HOME}/Library/Fonts/3270Medium.ttf ] ; then
      mkdir /tmp/$$
      cd /tmp/$$
      git clone https://github.com/powerline/fonts.git
      cd fonts
      ./install.sh
      cd ${HOME}
      echo NOTE- You must install iterm2, and set the profile font to a
      echo powerline one
    fi

    grep -q fish /etc/shells || echo Add /usr/local/bin/fish to /etc/shells
    grep -q fish /etc/shells || echo Run chsh -s /usr/local/bin/fish
  else
    if [ -f /etc/redhat-release ] ; then
      # CentOS!
      sudo yum install -y vim tmux git wget fish
    fi

    if [ -f /etc/debian_version ] ; then
      # Ubuntu!
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
        tmux git vim wget vim-syntastic fish powerline
    fi

    [ -d ${HOME}/.local/share/omf ] || (
      # curl -L https://get.oh-my.fish | fish
      curl -L github.com/oh-my-fish/oh-my-fish/raw/master/bin/install \
        > /tmp/install-fish
      chmod a+x /tmp/install-fish
      /tmp/install-fish --noninteractive
    )
    fish -c 'set -U fish_user_paths /snap/bin $fish_user_paths'
    fish -c 'omf install bobthefish'
    sudo chsh -s /usr/bin/fish ${USER}
  fi
fi
