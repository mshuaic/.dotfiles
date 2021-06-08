# zsh copy-paste command using emacs keybinding

function x-copy-region-as-kill () {
    zle copy-region-as-kill
    print -rn -- $CUTBUFFER | xclip -i -selection clipboard
    zle deactivate-region
}

function x-kill-region () {
    zle kill-region
    print -rn $CUTBUFFER | xclip -i -selection clipboard
}

function x-yank () {
    CUTBUFFER=$(xclip -o -selection clipboard </dev/null)
    zle yank
}

zle -N x-copy-region-as-kill
zle -N x-kill-region
zle -N x-yank

function () {    
    bindkey '\ew' x-copy-region-as-kill
    bindkey '^W' x-kill-region
    bindkey '^Y' x-yank
}
