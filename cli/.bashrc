[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias grep='grep --color=auto'
alias ga='git add'
alias gaa='git add --all'
alias gcl='git clone'
alias gca='git commit --all'
alias gp='git push'
alias gpl='git pull'
PS1='[\u@\h \W]\$ '

if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
  exec tmux new-session -A -s ${USER} >/dev/null 2>&1
fi
