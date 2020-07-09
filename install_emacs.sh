
tag=`curl -s https://github.com/emacs-mirror/emacs/tags/ \
| egrep "^\s+emacs" | sort -r | tr -d ' ' | head -1`

filename="$tag.tar.gz"
# url="http://ftp.wayne.edu/gnu/emacs/$filename"
url="https://github.com/emacs-mirror/emacs/archive/$filename"
cpath=`pwd`
folder='emacs'

cd /tmp
if [ ! -f "$filename" ]; then
    wget $url    
fi

if [ -d "$folder" ]; then
    echo "Removing $folder"
    rm -rf "$folder"
fi
mkdir $folder
tar -xvzf $filename -C $folder --strip-components=1
cd $folder
./autogen.sh
./configure && make
sudo make install

cd $cpath

emacs --fg-daemon -f jedi:install-server -f save-buffers-kill-emacs

pip install epc jedi

hash -r
