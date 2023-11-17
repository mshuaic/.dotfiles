#!/usr/bin/env bash

echo -e "If we have sudo,\n 
sudo mkdir /home/linuxbrew
sudo apt-get install build-essential procps curl file git zsh\n"

IFS=
echo "Press [ENTER] to resume ..."
read -s -n 1  key

if [[ $key != "" ]]; then
    exit 1
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
# echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.profile
# echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.zshenv


apps=(
    gcc
    tmux
    emacs
    pyenv
    pyenv-virtualenv
    fzf
    asdf
    xclip
    bat
    # feh
    trash-cli
    fd
    git
)

libs=(
    bzip2 libffi libxml2 libxmlsec1 openssl readline sqlite3 xz zlib ncurses tcl-tk
)

libs_to_install=( )

for lib in "${libs[@]}"; do
    if ! dpkg -s $lib >/dev/null 2>&1; then
	echo "$lib is not installed"
	libs_to_install+=( $lib )
    fi
done

brew install "${libs_to_install[@]}" "${apps[@]}"

# for python > 3.11
# https://github.com/pyenv/pyenv/issues/2499
# figure it out later

# install the latest python
for lib in "${libs[@]}"; do
    export LDFLAGS="$LDFLAGS -L$(brew --prefix $lib)/lib"
    export CPPFLAGS="$CPPFLAGS -I$(brew --prefix $lib)/include"
done
# echo 'eval "$(pyenv init --path)"' >> ~/.profile
# echo 'eval "$(pyenv init -)"' >> ~/.bashrc
pyenv install $(pyenv install --list | sed 's/^  //' | grep -v - | grep --invert-match 'dev\|a\|b' | tail -1)



# change login shell to zsh
#if ! command -v zsh &> /dev/null; then
#    brew install zsh
#    echo "exec $(which zsh) -l" >> ~/.profile
#    chsh -s /bin/sh
#else
#    chsh -s "$(which zsh)"
#fi

# TODO: refactoring this part 
git config --global user.email "mshuaic@users.noreply.github.com" 
git config --global user.name "Mark"
git config --global submodule.recurse true
git config --global core.excludesfile ~/.gitignore

# trash auto empty
if ! crontab -l | grep trash-empty >/dev/null; then
    (crontab -l ; echo "@daily $(which trash-empty) 30") | crontab -
fi

source toHome.sh
