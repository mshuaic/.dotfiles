# export DOTFILES=$(dirname "$(readlink -f -- "$0")")
# DOTFILES="$DOTFILES" sh $DOTFILES/tools/check_for_upgrade.sh

# stty -ixon

alias emacs="emacsclient -t"
alias e=emacs
alias octave="octave-cli"
alias ta="tmux a"
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
    alias rm='mv -b -t /tmp'
fi

if [[ "$TERM" == "tmux"* ]]; then
    export TMUX=1
fi

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
fi


if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
    # assume Zsh
    # setopt inc_append_history
    x-copy-region-as-kill () {
	# [[ "$REGION_ACTIVE" -ne 0 ]] && zle copy-region-as-
	zle copy-region-as-kill
	# print -rn -- $CUTBUFFER | xclip -selection clipboard -i
	print -rn -- $CUTBUFFER | xclip -i -selection clipboard
	zle deactivate-region
	# print -rn -- $CUTBUFFER | clipcopy 

    }
    zle -N x-copy-region-as-kill
    x-kill-region () {
	zle kill-region
	print -rn $CUTBUFFER | xclip -i -selection clipboard
    }
    zle -N x-kill-region
    x-yank () {
	CUTBUFFER=$(xclip -o -selection clipboard </dev/null)
	zle yank
    }
    zle -N x-yank
    bindkey -e '\ew' x-copy-region-as-kill
    bindkey -e '^W' x-kill-region
    bindkey -e '^Y' x-yank
fi

# Ethereum 
export PATH=$PATH:/home/mark/go-ethereum/build/bin


# local bin and library
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/.local/lib/pkgconfig:$HOME/.linuxbrew/lib/pkgconfig



# eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# eval "$(pyenv init --path)"

# export PATH="$HOME/.pyenv/bin:$PATH"
if [[ -f $HOME/.linuxbrew/bin/brew ]]; then
    eval $($HOME/.linuxbrew/bin/brew shellenv)
    # alias brew="env PATH=${PATH//$(pyenv root)\/shims:/} brew"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
# else
#     eval "$(pyenv virtualenv-init -)"
fi

# if [[ -f $HOME/.asdf/asdf.sh ]]; then
#     . $HOME/.asdf/asdf.sh
#     . $HOME/.asdf/completions/asdf.bash
# fi

eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

export LIBGL_ALWAYS_INDIRECT=1
# eval "$(pyenv init -)"

