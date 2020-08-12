cd $DOTFILES
# exec zsh
UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    echo "Up-to-date"
elif [ $LOCAL = $BASE ]; then
    echo "Need to pull"
    git pull https://github.com/mshuaic/dotfiles.git
    # DOTFILES="$DOTFILES" sh "$DOTFILES/tools/upgrade.sh"
elif [ $REMOTE = $BASE ]; then
    echo "Need to push"
else
    echo "Diverged"
fi

# }
#     echo "Need to push"
# else
#     
# fi



# # Migrate .zsh-update file to $ZSH_CACHE_DIR
# # if [[ -f ~/.zsh-update && ! -f "${ZSH_CACHE_DIR}/.zsh-update" ]]; then
# #     mv ~/.zsh-update "${ZSH_CACHE_DIR}/.zsh-update"
# # fi

# # # Cancel update if:
# # # - the automatic update is disabled.
# # # - the current user doesn't have write permissions nor owns the $ZSH directory.
# # # - git is unavailable on the system.
# # if [[ "$DISABLE_AUTO_UPDATE" = true ]] \
# #    || [[ ! -w "$ZSH" || ! -O "$ZSH" ]] \
# #    || ! command -v git &>/dev/null; then
# #     return
# # fi


# function current_epoch() {
#     zmodload zsh/datetime
#     echo $(( EPOCHSECONDS / 60 / 60 / 24 ))
# }

# function update_last_updated_file() {
#     echo "LAST_EPOCH=$(current_epoch)" >! "${DOTFILES}/.update"
# }

# function update_ohmyzsh() {
#     # ZSH="$ZSH" sh "$ZSH/tools/upgrade.sh"
#     DOTFILES="$DOTFILES" sh "$DOTFILES/tools/upgrade.sh"
#     update_last_updated_file
# }

# () {
#     emulate -L zsh

#     local epoch_target mtime option LAST_EPOCH

#     # Remove lock directory if older than a day
#     zmodload zsh/datetime
#     zmodload -F zsh/stat b:zstat
#     # if mtime=$(zstat +mtime "$DOTFILES/update.lock" 2>/dev/null); then
#     #     if (( (mtime + 3600 * 24) < EPOCHSECONDS )); then
#     #         command rm -rf "$DOTFILES/update.lock"
#     #     fi
#     # fi

#     # # Check for lock directory
#     # if ! command mkdir "$DOTFILES/update.lock" 2>/dev/null; then
#     #     return
#     # fi

#     # # Remove lock directory on exit. `return 1` is important for when trapping a SIGINT:
#     # #  The return status from the function is handled specially. If it is zero, the signal is
#     # #  assumed to have been handled, and execution continues normally. Otherwise, the shell
#     # #  will behave as interrupted except that the return status of the trap is retained.
#     # trap "command rm -rf '$DOTFILES/update.lock'; return 1" EXIT INT QUIT

#     # # Create or update .zsh-update file if missing or malformed
#     if ! source "${DOTFILES}/.update" 2>/dev/null || [[ -z "$LAST_EPOCH" ]]; then
#         update_last_updated_file
#         return
#     fi

#     # Number of days before trying to update again
#     epoch_target=${UPDATE_ZSH_DAYS:-13}
#     # Test if enough time has passed until the next update
#     if (( ( $(current_epoch) - $LAST_EPOCH ) < $epoch_target )); then
# 	# echo $epoch_target
#         return
#     fi

#     # Ask for confirmation before updating unless disabled
#     # if [[ "$DISABLE_UPDATE_PROMPT" = true ]]; then
#     update_ohmyzsh
#     # else
#     #     # input sink to swallow all characters typed before the prompt
#     #     # and add a newline if there wasn't one after characters typed
#     #     while read -t -k 1 option; do true; done
#     #     [[ "$option" != ($'\n'|"") ]] && echo

#     #     echo -n "[oh-my-zsh] Would you like to update? [Y/n] "
#     #     read -r -k 1 option
#     #     [[ "$option" != $'\n' ]] && echo
#     #     case "$option" in
#     #         [yY$'\n']) update_ohmyzsh ;;
#     #         [nN]) update_last_updated_file ;;
#     #     esac
#     # fi
# }

# unset -f current_epoch update_last_updated_file update_ohmyzsh
