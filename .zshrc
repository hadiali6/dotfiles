# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PS1='%~ $ '
PS1='%F{cyan}%~ %(?.%F{green}.%F{red})$%f '
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT='%F{magenta}${vcs_info_msg_0_}'
zstyle ':vcs_info:git:*' formats '%b'

set -o vi

alias ls='eza --color=auto'
alias grep='grep --color=auto'
alias wa='feh --bg-fill --random ~/wallpapers'
alias nv='nvim'
alias nvl='NVIM_APPNAME="lazyvim" nvim'
alias nv2='NVIM_APPNAME="nvim2" nvim'
alias nva='NVIM_APPNAME="nvim-ayamir" nvim'
alias gs='git status'
alias vol='wpctl get-volume @DEFAULT_AUDIO_SINK@'
alias awm='cd $AWM'
alias lj='luajit'
alias setrandr='wlr-randr --output DP-2 --mode 1920x1080@143.854996'
alias pullall='find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;'

export EDITOR='nvim'
export AWM=~/.config/awesome/

export ERSAVE=~/.local/share/Steam/steamapps/compatdata/1245620/pfx/drive_c/users/steamuser/AppData/Roaming/EldenRing/76561198289194338/
export ER_SC_SAVE=~/.local/share/Steam/steamapps/compatdata/3332966800/pfx/drive_c/users/steamuser/AppData/Roaming/EldenRing/76561198289194338/
export ERGAME=~/.local/share/Steam/steamapps/common/ELDEN\ RING/Game/mods/

export PATH=~/.npm-global/bin:$PATH
export PATH=~/.local/bin:$PATH
export PATH=~/.config/emacs/bin:$PATH
export PATH=~/go/bin:$PATH
export PATH=~/Downloads/zig-014-dev-367/:$PATH
