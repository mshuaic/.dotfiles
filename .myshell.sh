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

# only for WSL 
if [[ "$(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/p')" == "Microsoft" ]]; then
    export DISPLAY=localhost:0.0
    alias matlab="matlab.exe -nodesktop -nosplash -r"
    export work="/mnt/e/work"
    umask 022
fi


# if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
#     # assume Zsh
#     setopt inc_append_history
# elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
#     # assume Bash
#     export PROMPT_COMMAND="history -a; history -n"
# fi    


## GO setting ##
export GOPATH=$HOME/.local/go
export PATH=$PATH:$GOPATH/bin
