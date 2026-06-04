#!/bin/bash

set -o errexit -o nounset

echo INIT: packages

sudo apt-get update
sudo apt-get install --yes \
    curl git tmux alacritty ripgrep fzf bat tree htop ncdu network-manager

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

if [[ ! -d ~/repos/shlf ]]; then
    mkdir --parents ~/repos
    echo "  shlf: attempting to clone ..."
    git -C ~/repos/ clone git@github.com:nacezavrtanik/shlf.git
else
    echo "  shlf: already installed"
fi

if command -v uv > /dev/null 2>&1; then
    echo "  uv: already installed"
else
    echo "  uv: attempting to install uv ..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    uv --version
fi

if command -v calcure > /dev/null 2>&1; then
    echo "  calcure: already installed"
else
    uv tool install calcure
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
yellow='%x1b%x5b%x33%x33m'; blue='%x1b%x5b%x33%x34m'
comma='%x2c'; closing_parenthesis='%x29'
rule='--------------------------------------------------------------------------------'
pointer="$yellow -> "
separator="$blue$comma "
prefix="$blue ("
suffix="$blue$closing_parenthesis"
decorate="pointer=$pointer,separator=$separator,prefix=$prefix,suffix=$suffix"
custom_oneline_format="%C(blue)%h%C(auto)%(decorate:$decorate) %s"
custom_medium_format="%C(blue)%H%C(auto)%(decorate:$decorate)%n%C(brightblack)Author:%C(auto) %an %C(brightblack italic)<%ae>%n%C(reset)%C(brightblack)Date:  %C(auto) %ar %C(brightblack italic)<%ad>%n%n%C(reset)%C(white bold)%w(0,4)%s%n%C(reset)%C(white)%w(0,4,4)%+b%w()%n%C(black italic)$rule%C(reset)"

git config --global pretty.custom-oneline "$custom_oneline_format"
git config --global pretty.custom-medium "$custom_medium_format"
git config --global format.pretty custom-medium

git config --global log.graphColors 'blue'
git config --global color.decorate.HEAD 'yellow bold'
git config --global color.decorate.branch 'green bold'
git config --global color.decorate.remoteBranch 'magenta bold'
git config --global color.decorate.tag 'cyan bold'
git config --global color.decorate.stash 'red bold'
git config --global color.branch.current 'yellow'
git config --global color.branch.local 'green'
git config --global color.branch.remote 'magenta'
git config --global color.status.branch 'green bold'
git config --global color.advice.hint 'blue'
git config --global color.diff.meta 'brightblack italic'
git config --global color.diff.frag 'blue'
git config --global color.diff.func 'white bold'
git config --global color.diff.whitespace 'red red'

git config --global core.excludesfile ~/dotfiles/.gitignore_global
git config --global core.editor nvim
git config --global init.defaultbranch main
git config --global advice.statushints false
git config --global advice.detachedhead false
git config --global advice.suggestdetachinghead false
git config --global diff.tool nvimdiff
git config --global diff.noprefix true
git config --global diff.interhunkcontext 3
git config --global difftool.prompt false
git config --global alias.df 'difftool'
git config --global alias.adog 'log --all --graph --pretty=custom-oneline'
git config --global alias.adof '! git_pretty_log_with_fzf.sh'
git config --global trailer.ifExists addIfDifferent
echo "  git: done"

