if ! command -v brew &> /dev/null
then
    if [[ -f /nvme/markma/homebrew/bin/brew ]]; then
        eval $(/nvme/markma/homebrew/bin/brew shellenv)
    elif [[ -f $HOME/.linuxbrew/bin/brew ]]; then
        eval $($HOME/.linuxbrew/bin/brew shellenv)
    elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    fi
    
    # test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    # test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


