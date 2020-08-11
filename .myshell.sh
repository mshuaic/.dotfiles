export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# stty -ixon

# alias emacs="$EMACS_PLUGIN_LAUNCHER -nw"
alias emacs="emacsclient -t"
alias e=emacs
alias octave="octave-cli"
alias ta="tmux a"

set -o emacs

# disable CTRL-D window close in terminator (terminal emulator)
export IGNOREEOF=2
# set -o ignoreeof
 
# alias sudo='nocorrect sudo '
alias rm='trash'

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -c -a emacs"

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
    export CDPATH=/c/Users/mshua

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

    if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
        agent_start  >| /dev/null 2>&1
    #     ssh-add >| /dev/null 2>&1
    # elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    #     ssh-add >| /dev/null 2>&1
    fi

    unset env

    trap 'test -n "$SSH_AUTH_SOCK" && eval `/usr/bin/ssh-agent -k`' 0
    
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

# elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
#     # assume Bash
#     export PROMPT_COMMAND="history -a; history -n"
# fi    

export GOPATH=$HOME/.local/go
export PATH=$PATH:$GOPATH/bin

# Ethereum 
export PATH=$PATH:/home/mark/go-ethereum/build/bin

# if [ -x "$(command -v fuck)" ]; then
#     eval $(thefuck --alias)
# fi


# local bin and library
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH

LEETCODE_CLI=$HOME/leetcode/.cli
alias leetcode="NODE_NO_WARNINGS=1 $LEETCODE_CLI/bin/leetcode"
###-begin-leetcode-completions-###
#
# yargs command completion script
#
# Installation: /home/mark/leetcode-cli/bin/leetcode completion >> ~/.bashrc
#    or /home/mark/leetcode-cli/bin/leetcode completion >> ~/.bash_profile on OSX.
#
_yargs_completions()
{
    local cur_word args type_list

    cur_word="${COMP_WORDS[COMP_CWORD]}"
    args=("${COMP_WORDS[@]}")

    # ask yargs to generate completions.
    type_list=$($LEETCODE_CLI/bin/leetcode --get-yargs-completions "${args[@]}")

    COMPREPLY=( $(compgen -W "${type_list}" -- ${cur_word}) )

    # if no match was found, fall back to filename completion
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY=( $(compgen -f -- "${cur_word}" ) )
    fi

    return 0
}
complete -F _yargs_completions leetcode
###-end-leetcode-completions-###

