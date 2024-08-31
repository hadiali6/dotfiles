#
# ~/.bashrc
#

[[ $- != *i* ]] && return

PS1='\w \\$ '

alias ls='eza --color=auto'
alias grep='grep --color=auto'
alias wa='feh --bg-fill --random ~/wallpapers'
alias nv='nvim'
alias nvt='NVIM_APPNAME="test-nvim" nvim'
alias gs='git status'
alias vol='wpctl get-volume @DEFAULT_AUDIO_SINK@'
alias awm='cd $AWM'

export EDITOR='nvim'
export AWM=~/.config/awesome/

[ -f "~/.ghcup/env" ] && source "~/.ghcup/env" # ghcup-env
export PATH=~/.npm-global/bin:$PATH
export PATH=~/.local/bin:$PATH
export PATH=~/.config/emacs/bin:$PATH
export PATH=~/go/bin:$PATH

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
echo hi

# if [ "$TERM" != "xterm-256color" ]; then set -o vi fi
