#!/bin/bash

[ "$1" ] && VERSION="$1" || VERSION='3.10.0'

# pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# libs=(
#     bzip2 libffi libxml2 libxmlsec1 openssl readline sqlite3 xz zlib
# )

# # install the latest python
# for lib in "${libs[@]}"; do
#     export LDFLAGS="$LDFLAGS -L$(brew --prefix $lib)/lib"
#     export CPPFLAGS="$CPPFLAGS -I$(brew --prefix $lib)/include"
# done


# if failed using brew
# check this
# https://stackoverflow.com/questions/50036091/pyenv-zlib-error-on-macos
# https://docs.brew.sh/How-to-Build-Software-Outside-Homebrew-with-Homebrew-keg-only-Dependencies

# install python
env CFLAGS="-I$(brew --prefix)/include" CPPFLAGS="-I$(brew --prefix)/include"  LDFLAGS="-L$(brew --prefix)/lib" PYTHON_CONFIGURE_OPTS="CC=gcc-11" pyenv install $VERSION
pyenv global $VERSION
pip install --upgrade pip
pip install autopep8
pip install virtualenv
hash -r
