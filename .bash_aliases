alias tmux="TERM=xterm-256color tmux"

alias gg='git status'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gdv='git diff | vim -R'
alias ga='git add'
alias gau='git add --update'
alias gc='git commit -v'
alias gca='git commit -v -a'
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
fi
