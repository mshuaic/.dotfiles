#!/bin/sh

VERSION='3.8.3'

# pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


# install python
pyenv install $VERSION
pyenv global $VERSION
pip install --upgrade pip
pip install autopep8
pip install virtualenv
