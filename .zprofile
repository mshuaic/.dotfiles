if [[ -f $HOME/.linuxbrew/bin/brew ]]; then
    eval $($HOME/.linuxbrew/bin/brew shellenv)
     # alias brew="env PATH=${PATH//$(pyenv root)\/shims:/} brew"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
