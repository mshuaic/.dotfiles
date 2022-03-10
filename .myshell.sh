# export DOTFILES=$(dirname "$(readlink -f -- "$0")")
# DOTFILES="$DOTFILES" sh $DOTFILES/tools/check_for_upgrade.sh

# stty -ixon

alias emacs="emacsclient -t"
alias e=emacs
alias octave="octave-cli"
alias ta="tmux attach -E"
alias ximg='feh'
alias killall='killall -u `whoami`'

set -o emacs

# disable CTRL-D window close in terminator (terminal emulator)
export IGNOREEOF=2
# set -o ignoreeof
 
# alias sudo='nocorrect sudo '

if command -v trash > /dev/null; then
    alias rm='trash'
else
    mkdir -p /tmp/$USER
    alias rm='mv -b -t /tmp/$USER'
fi


# comment out this for tmux show-env
# if [[ "$TERM" == "tmux"* ]]; then
#     export TMUX=1
# fi

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -t"

# only for WSL 
if [[ "$(uname -r | sed -n 's/.*\( *microsoft *\).*/\L\1/pi')" == "microsoft" ]]; then

    # wsl2
    if grep -q "microsoft" /proc/version &>/dev/null; then
	# Requires: https://sourceforge.net/projects/vcxsrv/ (or alternative)
	export DISPLAY="$(/sbin/ip route | awk '/default/ { print $3 }'):0"
    else
	# wsl1
	if [ "$(umask)" = "0000" ]; then
	    umask 0022
	fi
	export DISPLAY=localhost:0.0
    fi
    alias matlab="matlab.exe -nodesktop -nosplash -r"
    # export work="/mnt/e/work"

    # mayby use WSLENV later
    # export CDPATH=$CDPATH:/c/Users/mshua/Desktop

    # ssh agent forwarding
    env=~/.ssh/agent.env

    agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

    agent_start () {
        (umask 077; ssh-agent >| "$env")
        . "$env" >| /dev/null ; }

    agent_load_env

    # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
    agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
    # echo $agent_run_state

    while [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; do
        agent_start  >| /dev/null 2>&1
	agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
	# echo "ssh-agent is not running"
    done

    trap 'test -n "$SSH_AUTH_SOCK" && eval `/usr/bin/ssh-agent -k`' 0

    export CDPATH=$CDPATH:.:~:~/.windir

    # SSH Socket
    # Removing Linux SSH socket and replacing it by link to wsl2-ssh-pageant socket
    # export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock !
    # ss -a | grep -q $SSH_AUTH_SOCK 
    # if [ $? -ne 0 ]; then
    # 	rm -f $SSH_AUTH_SOCK
    # 	setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:$HOME/.ssh/wsl2-ssh-pageant.exe &>/dev/null &
    # fi
    # # GPG Socket
    # # Removing Linux GPG Agent socket and replacing it by link to wsl2-ssh-pageant GPG socket
    # export GPG_AGENT_SOCK=$HOME/.gnupg/S.gpg-agent 
    # ss -a | grep -q $GPG_AGENT_SOCK 
    # if [ $? -ne 0 ]; then
    # 	rm -rf $GPG_AGENT_SOCK
    # 	setsid nohup socat UNIX-LISTEN:$GPG_AGENT_SOCK,fork EXEC:"$HOME/.ssh/wsl2-ssh-pageant.exe --gpg S.gpg-agent" &>/dev/null &
    # fi

fi



# local bin and library
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/.local/lib/pkgconfig:$HOME/.linuxbrew/lib/pkgconfig

####### HomeBrew ################################

if [[ -f $HOME/.linuxbrew/bin/brew ]]; then
    eval $($HOME/.linuxbrew/bin/brew shellenv)
    # alias brew="env PATH=${PATH//$(pyenv root)\/shims:/} brew"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

export HOMEBREW_NO_AUTO_UPDATE=1
################################################

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export LIBGL_ALWAYS_INDIRECT=1


# .cargo
export PATH=$PATH:$HOME/.cargo/bin

