[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias grep='grep --color=auto'

export EDITOR='nvim'
export MANPAGER='nvim +Man!'
export BAT_THEME='base16'
export QT_STYLE_OVERRIDE='kvantum'

source /usr/share/git/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=1
export GIT_PS1_STATESEPARATOR=" "
export GIT_PS1_DESCRIBE_STYLE=1
export GIT_PS1_SHOWCOLORHINTS=1
export PS1='\033[32;1m\u@\h\033[0m:\033[34;1m\w\[\033[00m\]$(__git_ps1) \$ '
