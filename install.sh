#!/bin/bash

echo_info() {
  echo -e "[\e[34mInfo\e[0m] $1"
}
echo_note() {
  echo -e "[\e[33mnote\e[0m] $1"
}
version_lte() {
  local smallerarg=$(echo -e "$1\n$2" | sort -V | head -n1)
  [ "$1" = "$smallerarg" ]
}
install_pkg() {
  echo_info "Installing $1"
  sudo apt-get install $1
}
add_ppa() {
  if ! grep -q $1 /etc/apt/sources.list /etc/apt/sources.list.d/*
  then
    sudo apt-add-repository "ppa:$2"
    sudo apt-get update
  fi
}
ensure_clone() {
  if [ -d "$2" ]
  then
    echo_info "Updating $2"
    pushd "$2"
    git pull
    popd
  else
    echo_info "Cloning $2"
    git clone --recursive "$1" "$2"
  fi
}
ensure_mkdir() {
  if [ ! -d "$1" ]
  then
    echo_info "Creating dir $1"
    mkdir "$1"
  else
    echo_info "Skipping mkdir $1"
  fi
}

echo_note "Might be a good idea to \e[36msudo apt-get update\e[0m first"

echo_info "Instaling pakages..."


install_pkg python-software-properties
install_pkg software-properties-common
install_pkg git
install_pkg build-essential
install_pkg libcurl4-gnutls-dev
install_pkg libav-tools
install_pkg libncurses-dev
install_pkg libssl-dev
install_pkg libreadline-dev
install_pkg zlib1g-dev
install_pkg htop
install_pkg cowsay
install_pkg octave
install_pkg ranger
install_pkg python-pygments
install_pkg highlight
install_pkg poppler-utils
install_pkg caca-utils
install_pkg w3m



# Updating tmux
# TMUX_VERSIONSTR=$(tmux -V)
# TMUX_VERSION=${TMUX_VERSIONSTR#tmux }
# if version_lte "$TMUX_VERSION" "1.9"
# then
#   echo_info "Doing fancy stuff to update tmux to 2.0"
#   sudo add-apt-repository ppa:pi-rho/dev
#   sudo apt-get update
#   sudo apt-get install tmux=2.0-1~ppa1~t
# else
#   echo_info "tmux is already at version 2.0 ... skipping tmux"
# fi
add_ppa pi-rho pi-rho/dev
install_pkg tmux=2.0.1~ppa1~t

add_ppa octave octave/stable
install_pkg octave

echo_info "Installing nodejs and npm"
if ! grep -q nodesource /etc/apt/sources.list /etc/apt/sources.list.d/*
then
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
fi
install_pkg nodejs

echo_info "Installing rbenv"
ensure_clone https://github.com/rbenv/rbenv.git ~/.rbenv
ensure_clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
if [ ! -d ~/.rbenv/versions/2.4.0 ]
then
  echo_info "Installing ruby 2.4.0 via rbenv"
  rbenv install 2.4.0
else
  echo_info "Skipping rbenv install 2.4.0"
fi
rbenv global 2.4.0

echo_info "Installing Bundler"
gem install bundler

echo_info "Installing Jekyll"
gem install jekyll

echo_info "Installing Clib"
ensure_clone https://github.com/clibs/clib.git /tmp/clib
pushd /tmp/clib
make
sudo make install
popd

echo_info "Installing vimfiles"
ensure_clone https://github.com/ErnWong/vimfiles-wsl ~/.vim

echo_info "Installing tmux plugin manager"
ensure_clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo_info "Installing dircolors-solarized"
ensure_clone https://github.com/seebi/dircolors-solarized ~/customisations-shell/dircolors-solarized

echo_info "Linking ~/.dircolors"

ln -nsf ~/customisations-shell/dircolors-solarized/dircolors.ansi-dark ~/.dircolors

echo_info "Installing sexy-bash-prompt"

(cd /tmp && git clone --depth 1 --config core.autocrlf=false https://github.com/twolfson/sexy-bash-prompt && cd sexy-bash-prompt && make install) && source ~/.bashrc
