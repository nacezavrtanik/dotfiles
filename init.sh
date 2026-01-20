#!/bin/bash

echo INIT: packages

sudo apt-get update
sudo apt-get install --yes git tmux alacritty ripgrep tree htop ncdu

# Compile nvim
if command -v nvim > /dev/null 2>&1; then
    echo "  nvim: already installed"
else
    echo "  nvim: attempting to compile from source ..."
    nvim_repo=/tmp/neovim-repo
    git clone --depth=1 --branch=nightly \
        https://github.com/neovim/neovim $nvim_repo
    cd $nvim_repo
    sudo apt-get install -y cmake
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd - > /dev/null
    rm -rf $nvim_repo
    nvim --version
fi


echo "INIT: configs"

# BASH
# Unlike with other configs below, we only *append* the custom config to the
# existing `.bashrc`, because we don't want to replace `.bashrc` entirely.
name=.bashrc
current=~/"$name"
config_line=". ~/dotfiles/bash/$name"
if grep -xq "$config_line" "$current"; then
    echo "  bash: skipped"
else
    touch ~/dotfiles/bash/local.sh
    echo "$config_line" >> "$current"
    echo "  bash: done"
fi

# VIM
name=.vimrc
current=~/"$name"
bin=~/dotfiles/vim/"$name"
if diff --new-file "$current" "$bin" > /dev/null; then
    echo "  vim: skipped"
else
    touch ~/dotfiles/vim/local.vim
    cp --backup=numbered "$bin" "$current"
    echo "  vim: done"
fi

# TMUX
name=.tmux.conf
current=~/"$name"
bin=~/dotfiles/tmux/"$name"
if diff --new-file "$current" "$bin" > /dev/null; then
    echo "  tmux: skipped"
else
    touch ~/dotfiles/tmux/tmux.local.conf
    cp --backup=numbered "$bin" "$current"
    echo "  tmux: done"
fi

# ALACRITTY
name=alacritty.toml
current=~/.config/alacritty/"$name"
bin=~/dotfiles/alacritty/"$name"
if diff --new-file "$current" "$bin" > /dev/null; then
    echo "  alacritty: skipped"
else
    touch ~/dotfiles/alacritty/local.toml
    mkdir --parents ~/.config/alacritty
    cp --backup=numbered "$bin" "$current"
    echo "  alacritty: done"
fi

# GIT
git config --global core.excludesfile ~/dotfiles/.gitignore_global
git config --global core.editor nvim
git config --global init.defaultbranch main
git config --global advice.detachedhead false
git config --global diff.tool nvimdiff
git config --global difftool.prompt false
git config --global alias.df "difftool"
git config --global alias.adog "log --all --decorate --oneline --graph"
echo "  git: done"

