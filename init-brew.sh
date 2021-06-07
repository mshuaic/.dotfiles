#!/usr/bin/env bash

echo -e "If we have sudo,\n 
sudo mkdir /home/linuxbrew
sudo apt-get install build-essential procps curl file git \n"

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
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile


apps=(
    gcc
    tmux
    emacs
    pyenv
    pyenv-virtualenv
    fzf
    asdf
    xclip
)

libs=(
    bzip2 libffi libxml2 libxmlsec1 openssl readline sqlite3 xz zlib
)

libs_to_install=( )

for lib in "${libs[@]}"; do
    if ! dpkg -s $lib >/dev/null 2>&1; then
	libs_to_install+=( $lib )
    fi
done

brew install "${libs_to_install[@]}" "${apps[@]}"


# install the latest python
for lib in "${libs_to_install[@]}"; do
    export LDFLAGS="$LDFLAGS -L$(brew --prefix $lib)/lib"
    export CPPFLAGS="$CPPFLAGS -I$(brew --prefix $lib)/include"
done
echo 'eval "$(pyenv init --path)"' >> ~/.profile
# echo 'eval "$(pyenv init -)"' >> ~/.bashrc
pyenv install $(pyenv install --list | sed 's/^  //' | grep -v - | grep --invert-match 'dev\|a\|b' | tail -1)




if ! command -v zsh &> /dev/null; then
    brew install zsh
    echo "exec $(which zsh) -l" >> ~/.profile
fi

git config --global user.email "mshuaic@users.noreply.github.com" 
git config --global user.name "Mark"

source toHome.sh
