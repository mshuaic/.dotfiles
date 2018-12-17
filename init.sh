sudo apt-get update
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
     libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
     xz-utils tk-dev libffi-dev jq xclip libevent-dev texinfo build-essential texinfo libx11-dev \
	 libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev \
	libncurses-dev libxpm-dev automake autoconf libevent-dev libgtk-3-dev mailutils libgnutls-dev 

# libgtk2.0-dev libgnutls-dev

# pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
# echo 'export PATH="~/.pyenv/bin:$PATH"' >> ~/.bashrc
# echo 'eval "$(pyenv init -)"' >> ~/.bashrc
# echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc


# docker 
# curl -fsSL get.docker.com -o get-docker.sh
# sh get-docker.sh

# sudo groupadd docker
# sudo usermod -aG docker $USER


# install python
pyenv install 3.7.0
pyenv global 3.7.0
pip install --upgrade pip
pip install autopep8
pip install virtualenv

git config --global user.email "mshuaic@hotmail.com" 
git config --global user.name "Mark"

bash install_tmux.sh
bash install_emacs.sh

cp .bashrc .emacs .tmux.conf .inputrc ~
