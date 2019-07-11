
filename='emacs-26.2.tar.gz'
url="http://ftp.wayne.edu/gnu/emacs/$filename"
cpath=`pwd`
folder='emacs'

cd /tmp
wget $url
mkdir $folder
tar -xzf $filename -C $folder --strip-components=1
cd $folder
./configure && make
sudo make install

cd $cpath

emacs --fg-daemon -f jedi:install-server -f save-buffers-kill-emacs

pip install epc jedi
