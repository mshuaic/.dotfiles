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
    # env=~/.ssh/agent.env

    # agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

    # agent_start () {
    #     (umask 077; ssh-agent >| "$env")
    #     . "$env" >| /dev/null ; }

    # agent_load_env

    # # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
    # agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
    # # echo $agent_run_state

    # while [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; do
    #     agent_start  >| /dev/null 2>&1
    # 	agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
    # 	# echo "ssh-agent is not running"
    # done

    # trap 'test -n "$SSH_AUTH_SOCK" && eval `/usr/bin/ssh-agent -k`' 0

    export CDPATH=$CDPATH:.:~:~/.windir

    export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
    if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
      command rm -f "$SSH_AUTH_SOCK"
      wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
      if test -x "$wsl2_ssh_pageant_bin"; then
	(setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
      else
	echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
      fi
      unset wsl2_ssh_pageant_bin
    fi


    export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"    
    if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
	command rm -rf "$GPG_AGENT_SOCK"
	wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
	if test -x "$wsl2_ssh_pageant_bin"; then
	    (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin -gpgConfigBasepath 'C:/Users/mshua/AppData/Local/gnupg' --gpg S.gpg-agent" >/dev/null 2>&1 &)
	    # (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin -gpgConfigBasepath $(wslvar LOCALAPPDATA\\gnupg) --gpg S.gpg-agent" >/dev/null 2>&1 &)
	else
	    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
	fi
	unset wsl2_ssh_pageant_bin
    fi
    
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

