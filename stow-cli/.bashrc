[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias grep='grep --color=auto'

export EDITOR='nvim'
export MANPAGER='nvim +Man!'
export QT_STYLE_OVERRIDE='kvantum'

source /usr/share/git/completion/git-prompt.sh
export GIT_PS1_SHOWCOLORHINTS=true
export PS1='\n\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1)\n\$ '

# if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
#   exec tmux new-session -A -s ${USER} >/dev/null 2>&1
# fi
