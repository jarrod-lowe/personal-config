#!/bin/bash -eu
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

if [ ! "${1-}" = "-n" ] ; then
  if [ -f /etc/redhat-release ] ; then
    # CentOS!
    sudo yum install -y vim tmux git wget
  fi

  if [ -f /etc/debian_version ] ; then
    # Ubuntu!
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y tmux git vim wget vim-syntastic
  fi
fi
