sudo apt-get update

sudo sh -c "echo "US/Eastern" > /etc/timezone"
sudo dpkg-reconfigure -f noninteractive tzdata
sudo debconf-set-selections <<< "postfix postfix/mailname string $HOSTNAME"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
     libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
     xz-utils tk-dev libffi-dev jq xclip libevent-dev texinfo build-essential texinfo libx11-dev \
     libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libncurses-dev libxpm-dev \
     automake autoconf libevent-dev libgtk-3-dev mailutils libgnutls28-dev aspell-en zip\
     xauth x11-apps software-properties-common fzf direnv
	 

# libgtk2.0-dev libgnutls-dev


# docker 
# curl -fsSL get.docker.com -o get-docker.sh
# sh get-docker.sh

# sudo groupadd docker
# sudo usermod -aG docker $USER

git config --global user.email "mshuaic@users.noreply.github.com" 
git config --global user.name "Mark"


bash install_python.sh
bash install_tmux.sh
bash install_emacs.sh

bash toHome.sh
