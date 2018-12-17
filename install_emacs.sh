url='http://ftp.wayne.edu/gnu/emacs/emacs-26.1.tar.gz'
filename='emacs-26.1.tar.gz'
cpath=`pwd`
folder='emacs'

cd /tmp
wget $url
mkdir $folder
tar -xf $filename -C $folder --strip-components=1
cd $folder
./configure && make
sudo make install

cd $cpath

