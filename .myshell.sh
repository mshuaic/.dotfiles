export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

stty -ixon

alias emacs="emacs -nw"
alias octave="octave-cli"

set -o emacs

# disable CTRL-D window close in terminator (terminal emulator)
export IGNOREEOF=2
# set -o ignoreeof
 
# alias rm='mv -b -t /tmp'

export VISUAL="emacs -nw"
export EDITOR="$VISUAL"

# only for WSL 
if [[ "$(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/p')" == "Microsoft" ]]; then
    export DISPLAY=localhost:0.0
    alias matlab="matlab.exe -nodesktop -nosplash -r"
    # export work="/mnt/e/work"
    umask 022
    # mayby use WSLENV later
    export CDPATH=/mnt/c/Users/mshua
fi


if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
    # assume Zsh
    # setopt inc_append_history
    x-copy-region-as-kill () {
	# [[ "$REGION_ACTIVE" -ne 0 ]] && zle copy-region-as-
	zle copy-region-as-kill
	# print -rn -- $CUTBUFFER | xclip -selection clipboard -i
	print -rn -- $CUTBUFFER | xclip -i
	zle deactivate-region
	# print -rn -- $CUTBUFFER | clipcopy 

    }
    zle -N x-copy-region-as-kill
    x-kill-region () {
	zle kill-region
	print -rn $CUTBUFFER | xclip -i 
    }
    zle -N x-kill-region
    x-yank () {
	CUTBUFFER=$(xclip -o </dev/null)
	zle yank
    }
    zle -N x-yank
    bindkey -e '\ew' x-copy-region-as-kill
    bindkey -e '^W' x-kill-region
    bindkey -e '^Y' x-yank
fi
# elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
#     # assume Bash
#     export PROMPT_COMMAND="history -a; history -n"
# fi    

export GOPATH=$HOME/.local/go
export PATH=$PATH:$GOPATH/bin

# Ethereum 
export PATH=$PATH:/home/mark/go-ethereum/build/bin

if [ -x "$(command -v fuck)" ]; then
    eval $(thefuck --alias)
fi


# local bin and library
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH



# ssh agent forwarding
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    # ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

trap 'test -n "$SSH_AUTH_SOCK" && eval `/usr/bin/ssh-agent -k`' 0
