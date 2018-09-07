sudo apt-get update
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
     libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
     xz-utils tk-dev libffi-dev

sudo apt install -y xclip libevent-dev texinfo build-essential texinfo libx11-dev \
	 libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk2.0-dev \
	libncurses-dev libxpm-dev automake autoconf libgnutls-dev mailutils



# pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
# echo 'export PATH="~/.pyenv/bin:$PATH"' >> ~/.bashrc
# echo 'eval "$(pyenv init -)"' >> ~/.bashrc
# echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

pip install autopep8
pip install virtualenv

# docker 
# curl -fsSL get.docker.com -o get-docker.sh
# sh get-docker.sh

# sudo groupadd docker
# sudo usermod -aG docker $USER


# install python
pyenv install 3.7.0

git config --global user.email "mshuaic@hotmail.com" 
git config --global user.name "Mark"
