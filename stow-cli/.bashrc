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
export FZF_ALT_C_OPTS="--walker-skip .cache,.config/discordcanary,.config/QQ,.local/share,.local/state,.mozilla,.steam,.git,node_modules"

export HISTCONTROL="erasedups:ignorespace"

shopt -s autocd
shopt -s checkwinsize
shopt -s extglob
complete -f -X '*.@(jpg|jpeg|mjpg|mjpeg|gif|bmp|pbm|pgm|ppm|tga|xbm|xpm|tif|tiff|png|svg|svgz|mng|pcx|mov|mpg|mpeg|m2v|mkv|webm|ogm|mp4|m4v|mp4v|vob|qt|nuv|wmv|asf|rm|rmvb|flc|avi|fli|flv|gl|dl|ogv|ogx|aac|au|flac|m4a|mid|midi|mka|mp3|mpc|ogg|ra|wav|oga|opus|spx|xspf|pdf)' nvim grep

clear-screen-keep-sb() {
  printf '\e[%dS' $((LINES - 1))
  tput -x clear
}
bind -x '"\C-l":"clear-screen-keep-sb"'

osc7_cwd() {
  local strlen=${#PWD}
  local encoded=""
  local pos c o
  for ((pos = 0; pos < strlen; pos++)); do
    c=${PWD:$pos:1}
    case "$c" in
    [-/:_.!\'\(\)~[:alnum:]]) o="${c}" ;;
    *) printf -v o '%%%02X' "'${c}" ;;
    esac
    encoded+="${o}"
  done
  printf '\e]7;file://%s%s\e\\' "${HOSTNAME}" "${encoded}"
}
PROMPT_COMMAND=${PROMPT_COMMAND:+${PROMPT_COMMAND%;}; }osc7_cwd

. /usr/share/git/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_STATESEPARATOR=" "
GIT_PS1_DESCRIBE_STYLE=1
GIT_PS1_SHOWCOLORHINTS=1
PS1="\[\033[32;1m\]\u@\h\[\033[0m\]:\[\033[34;1m\]\w\[\033[00m\]\$(__git_ps1) \$ "
