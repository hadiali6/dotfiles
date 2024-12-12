# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='%F{cyan}%~ %(?.%F{green}.%F{red})$%f '
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT='%F{magenta}${vcs_info_msg_0_}'
zstyle ':vcs_info:git:*' formats '%b'

bindkey -v
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=5000
setopt autocd extendedglob nomatch notify
unsetopt beep
zstyle :compinstall filename '/home/hadi/.zshrc'

autoload -Uz compinit
compinit

export GOPATH=~/.local/go
export PATH=$GOPATH/bin/:$PATH
export PATH=~/.npm-global/bin:$PATH
export PATH=~/.local/bin:$PATH
export PATH=~/.config/emacs/bin:$PATH

export AWM=~/.config/awesome/
export EDITOR='nvim'

alias ls='eza --color=auto'
alias grep='grep --color=auto'
alias nv='nvim'
alias gs='git status'
alias vol='wpctl get-volume @DEFAULT_AUDIO_SINK@'
alias awm='cd $AWM'
alias lj='luajit'
alias setrandr='wlr-randr --output DP-2 --mode 1920x1080@143.854996'
alias pullall='find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;'
alias zbr='zig build run'
alias setnight='ddcutil setvcp 10 20'
alias setday='ddcutil setvcp 10 80'
alias setsshon='sudo systemctl enable sshd.service && sudo systemctl enable tailscaled.service && sudo systemctl start sshd.service && sudo systemctl start tailscaled.service'
alias setsshoff='sudo systemctl disable sshd.service && sudo systemctl disable tailscaled.service && sudo systemctl stop sshd.service && sudo systemctl stop tailscaled.service'
alias lfcd='cd "$(command lf -print-last-dir "$@")"'
