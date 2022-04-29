# export DOTFILES=$(dirname "$(readlink -f -- "$0")")
# DOTFILES="$DOTFILES" sh $DOTFILES/tools/check_for_upgrade.sh

# stty -ixon

set -o emacs

if [ $TMUX ]; then
    alias emacs="emacsclient -t -s /tmp/emacs$UID/$(tmux display-message -p "#S")"
else
    alias emacs="emacsclient -t -s /tmp/emacs$UID/server"
fi
alias e="emacs"
alias octave="octave-cli"
alias t="tmux new -s"
alias ta="tmux attach -E"
alias ximg='feh'
alias killall='killall -u `whoami`'


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


