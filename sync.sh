rhosts=(170.140.151.240 170.140.151.87 170.140.151.91)
files=(.emacs .tmux.conf .inputrc)
command='rsync -azP'
rdir='$HOME/'
ldir="$HOME/"
user='mark'


for host in "${rhosts[@]}"; do
    for file in "${files[@]}"; do
	$command $ldir$file $user@$host:$rdir$file
    done    
done
