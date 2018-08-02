sudo apt-get update
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
     libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
     xz-utils tk-dev libffi-dev

sudo apt install -y emacs25
sudo apt install -y xclip

# pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
# echo 'export PATH="~/.pyenv/bin:$PATH"' >> ~/.bashrc
# echo 'eval "$(pyenv init -)"' >> ~/.bashrc
# echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

# docker 
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

sudo groupadd docker
sudo usermod -aG docker $USER


# install python 3.6.5
pyenv install 3.6.5
