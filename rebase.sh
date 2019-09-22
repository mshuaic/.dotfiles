git config --global user.email "mshuaic@users.noreply.github.com"
git rebase -i
git commit --amend --reset-author
git rebase --continue
git push
