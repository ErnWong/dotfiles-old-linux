alias tmux="tmux-next"

alias gg='git status'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gdv='git diff | vim -R'
alias ga='git add'
alias gau='git add --update'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gst='git stash'
alias gsts='git stash save'
alias gstl='git stash list'
alias gsta='git stash apply'
alias gstp='git stash pop'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcot='git checkout -t'
alias gcobt='git checkout -b -t'
alias gcotb='git checkout -b -t'
alias glog='git log'
alias glogg='git log --decorate --oneline --graph'

if uname -r | grep -q 'Microsoft'
then
  alias vsdevcmd='cmd.exe /k "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat"'
  vsdev()
  {
    local CURRENT_DIR_WINDOWS=$(pwd | sed -e 's/\/mnt\/\([abcdef]\)/\U\1:/')
    cmd.exe /c "\"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat\" && cd /d \"$CURRENT_DIR_WINDOWS\" && $@"
  }
fi
