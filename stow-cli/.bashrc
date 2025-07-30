[[ $- != *i* ]] && return

alias ls='ls --color=auto --group-directories-first'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias grep='grep --color=auto'
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
[[ -f /etc/profile.d/lfcd.sh ]] && . /etc/profile.d/lfcd.sh
[[ -f /usr/share/doc/pkgfile/command-not-found.bash ]] && . /usr/share/doc/pkgfile/command-not-found.bash

export FZF_CTRL_T_OPTS="--walker-skip .cache,.config/discordcanary,.config/QQ,.local/share,.local/state,.mozilla,.steam,.git,node_modules"

export HISTCONTROL="erasedups:ignorespace"
shopt -s autocd
shopt -s checkwinsize

clear-screen-keep-sb() {
  printf '\e[%dS' $((LINES - 1))
  tput -x clear
}
bind -x '"\C-l":"clear-screen-keep-sb"'

. /usr/share/git/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_STATESEPARATOR=" "
GIT_PS1_DESCRIBE_STYLE=1
GIT_PS1_SHOWCOLORHINTS=1
PS1="\[\033[32;1m\]\u@\h\[\033[0m\]:\[\033[34;1m\]\w\[\033[00m\]\$(__git_ps1) \$ "
