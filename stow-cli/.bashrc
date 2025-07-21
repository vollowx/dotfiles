[[ $- != *i* ]] && return

alias ls='ls --color=auto --group-directories-first'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias grep='grep --color=auto'
. /etc/profile.d/lfcd.sh

. /usr/share/git/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_STATESEPARATOR=" "
GIT_PS1_DESCRIBE_STYLE=1
GIT_PS1_SHOWCOLORHINTS=1
PS1='\033[32;1m\u@\h\033[0m:\033[34;1m\w\[\033[00m\]$(__git_ps1) \$ '
