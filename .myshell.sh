# export DOTFILES=$(dirname "$(readlink -f -- "$0")")
# DOTFILES="$DOTFILES" sh $DOTFILES/tools/check_for_upgrade.sh

# stty -ixon

set -o emacs

if [ $TMUX ]; then
    alias emacs="emacsclient -t -s $(tmux display-message -p "#S")"
else
    alias emacs="emacsclient -t -s default"
fi
alias e="emacs"
alias octave="octave-cli"
alias t="tmux new -s"
alias ta="tmux attach"
alias ximg='feh'
alias killall='killall -u `whoami`'
export UID=$UID
export LSP_USE_PLISTS=true


# disable CTRL-D window close in terminator (terminal emulator)
export IGNOREEOF=2
# set -o ignoreeof
 

if command -v trash > /dev/null; then
    alias rm='trash'
else
    mkdir -p /tmp/$USER
    alias rm='mv -b -t /tmp/$USER'
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

    export CDPATH=$CDPATH:.:~:~/.windir

    ULIMIT=65536
    if [[ "$(ulimit -n)" != $ULIMIT ]]; then
        sudo prlimit --nofile=$ULIMIT:$ULIMIT --pid $$
        exec zsh
    fi
fi



# local bin and library
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/.local/lib/pkgconfig:$HOME/.linuxbrew/lib/pkgconfig

####### HomeBrew ################################

export HOMEBREW_NO_AUTO_UPDATE=1
################################################

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export LIBGL_ALWAYS_INDIRECT=1


# .cargo
export PATH=$PATH:$HOME/.cargo/bin


############# fzf ###################
export FZF_COMPLETION_OPTS='--border --info=inline'
# fzf's command
export FZF_DEFAULT_COMMAND="fd | cut -c 3-"
# CTRL-T's command
export FZF_CTRL_T_COMMAND="fd | cut -c 3-"
export FZF_CTRL_T_OPTS='--preview "bat --style=numbers --color=always --line-range :500 {}"'
# ALT-C's command
export FZF_ALT_C_COMMAND="fd --type d |  cut -c 3-"
export FZF_ALT_C_OPTS='--preview "tree -C {} | head -200"'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d -d 1 --follow --exclude ".git" . "$1"
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}
#####################################

if [ -f $HOME/.aliases ]; then
    . $HOME/.aliases
fi

export GOBIN="$HOME/.local/bin"

. /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh
