sudo apt-get update

sudo sh -c "echo "US/Eastern" > /etc/timezone"
dpkg-reconfigure -f noninteractive tzdata
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
     libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
     xz-utils tk-dev libffi-dev jq xclip libevent-dev texinfo build-essential texinfo libx11-dev \
     libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libncurses-dev libxpm-dev \
     automake autoconf libevent-dev libgtk-3-dev mailutils libgnutls28-dev aspell-en zip\
     xauth x11-apps
	 

# libgtk2.0-dev libgnutls-dev

# pyenv
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

cp .bashrc .emacs .tmux.conf .inputrc .myshell.sh $HOME

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


# emacs --fg-daemon -f jedi:install-server -f save-buffers-kill-emacs

source .bashrc
