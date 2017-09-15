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

echo_info "Instaling packages..."


install_pkg python-software-properties
install_pkg software-properties-common
install_pkg git
install_pkg build-essential
install_pkg cmake
install_pkg execstack
install_pkg libav-tools
install_pkg libavcodec-dev
install_pkg libavformat-dev
install_pkg libcurl4-gnutls-dev
install_pkg libdc1394-22-dev
install_pkg libgtk2.0-dev
install_pkg libjasper-dev
install_pkg libjpeg-dev
install_pkg libncurses-dev
install_pkg libpng-dev
install_pkg libreadline-dev
install_pkg libssl-dev
install_pkg libswscale-dev
install_pkg libtbb2
install_pkg libtbb-dev
install_pkg libtiff-dev
install_pkg pkg-config
install_pkg zlib1g-dev
install_pkg htop
install_pkg cowsay
install_pkg octave
install_pkg ranger
install_pkg python-pygments
install_pkg python-dev
install_pkg python-numpy
install_pkg highlight
install_pkg poppler-utils
install_pkg caca-utils
install_pkg w3m
install_pkg gifsicle
install_pkg imagemagick
install_pkg colortest



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

# No longer needed for Ubuntu xenial:
# echo_info "Adding ppa:pi-rho/dev"
# add_ppa pi-rho pi-rho/dev
# install_pkg tmux=2.0-1~ppa1~t
install_pkg tmux

echo_info "Adding ppa:octave/stable"
add_ppa octave octave/stable
install_pkg octave

echo_info "Installing nodejs and npm"
if ! grep -q nodesource /etc/apt/sources.list /etc/apt/sources.list.d/*
then
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
fi
install_pkg nodejs

echo_info "Checking sass-lint"
if hash sass-lint 2>/dev/null
then
  echo_info "Skipping sass-lint"
else
  echo_info "Installing sass-lint"
  sudo npm install -g sass-lint
fi

echo_info "Installing rbenv"
ensure_clone https://github.com/rbenv/rbenv.git ~/.rbenv
ensure_clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
if hash rbenv 2>/dev/null
then
  echo_info "Skipping rbenv setting up"
else
  echo_info "Setting up rbenv"
  pushd ~/.rbenv
  src/configure
  make -C src
  popd
  echo_info "Temporarily add to PATH for this session"
  export PATH="$HOME/.rbenv/bin:$PATH"
  export PATH="$HOME/.rbenv/shims:$PATH"
fi
if [ ! -d ~/.rbenv/versions/2.4.0 ]
then
  echo_info "Installing ruby 2.4.0 via rbenv"
  rbenv install 2.4.0
else
  echo_info "Skipping rbenv install 2.4.0"
fi
rbenv global 2.4.0

echo_info "Checking Bundler"
if gem list -i "^bundler$" >/dev/null
then
  echo_info "Skipping Bundler"
else
  echo_info "Installing Bundler"
  gem install bundler
fi

echo_info "Checking Jekyll"
if gem list -i "^jekyll$" >/dev/null
then
  echo_info "Skipping Jekyll"
else
  echo_info "Installing Jekyll"
  gem install jekyll
fi

echo_info "Installing Clib"
ensure_clone https://github.com/clibs/clib.git /tmp/clib
pushd /tmp/clib
make
sudo make install
popd

echo_info "Installing vimfiles"
ensure_clone https://github.com/ErnWong/vimfiles-wsl ~/.vim

echo_info "Setting up tmux"

echo_info "Linking ~/.tmux.conf"
ln -nsf ~/.dotfiles/.tmux.conf ~/.tmux.conf

echo_info "Linking ~/.tmux"
ln -nsf ~/.dotfiles/.tmux ~/.tmux

ensure_clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo_info "Installing tpm plugins"
~/.tmux/plugins/tpm/bin/install_plugins

echo_info "Updating tpm plugins"
~/.tmux/plugins/tpm/bin/update_plugins all

echo_info "Installing dircolors-solarized"
ensure_clone https://github.com/seebi/dircolors-solarized ~/customisations-shell/dircolors-solarized

echo_info "Linking ~/.dircolors"
ln -nsf ~/customisations-shell/dircolors-solarized/dircolors.ansi-dark ~/.dircolors

echo_info "Installing base16-shell"
ensure_clone https://github.com/chriskempson/base16-shell ~/.config//base16-shell

echo_info "Installing bashmarks"
ensure_clone https://github.com/huyng/bashmarks.git ~/customisations-shell/bashmarks
if [ -e ~/.local/bin/bashmarks.sh ]
then
  echo_info "Skipping bashmarks config"
else
  echo_info "Configuring bashmarks"
  pushd ~/customisations-shell/bashmarks
  sudo make install
  popd
fi

echo_info "Linking bash dotfiles"
ln -nsf ~/.dotfiles/.bashrc ~/.bashrc
ln -nsf ~/.dotfiles/.bash_profile ~/.bash_profile
ln -nsf ~/.dotfiles/.bash_logout ~/.bash_logout
ln -nsf ~/.dotfiles/.bash_aliases ~/.bash_aliases

echo_info "Linking other dotfiles"
ln -nsf ~/.dotfiles/.inputrc ~/.inputrc

if hash opencv_version 2>/dev/null
then
  echo_info "Skipping OpenCV"
else
  echo_info "Installing OpenCV"
  ensure_mkdir ~/tool-sources
  ensure_clone https://github.com/opencv/opencv.git ~/tool-sources/opencv
  ensure_mkdir ~/tool-sources/opencv/release
  pushd ~/tool-sources/opencv/release
  cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
  make
  sudo make install
  echo_info "Configuring OpenCV - Clearing execstack flags"
  sudo execstack -c /usr/local/lib/*opencv*.so*
  popd
fi

echo_info "If all went well,...well, it's a good thing we made it to"
echo_info "the end for starters. However, if all went well, welcome"
echo_info "back home! Dotfiles installation complete."
