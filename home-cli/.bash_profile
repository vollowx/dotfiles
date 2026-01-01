export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_DATA_DIRS="/usr/local/share:/usr/share:$HOME/.local/share"

export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export MANPAGER="nvim +Man!"
export TERMINAL="foot"
export BROWSER="firefox"
export GPG_TTY=$(tty)
export GOPATH="$XDG_DATA_HOME/go"

export PATH=~/.local/bin:$PATH
export PATH=$GOPATH/bin:$PATH

export BAT_THEME="base16"
export FZF_DEFAULT_OPTS="--info=inline-right \
  --no-scrollbar \
  --no-separator \
  --border=none \
  --preview-border=none \
  --height=~75% \
  --reverse \
  --multi \
  --ansi \
  --color=fg:-1,bg:-1,hl:bold:cyan \
  --color=fg+:-1,bg+:-1,hl+:bold:cyan \
  --color=border:white,preview-border:white \
  --color=marker:bold:cyan,prompt:bold:blue,pointer:bold:blue \
  --color=gutter:-1,info:bold:blue,spinner:yellow,header:white"
export FZF_DEFAULT_COMMAND="fd -p -H -L -td -tf -tl -c=always"
export FZF_ALT_C_COMMAND="$fd -p -H -L -td -c=always"
export FZF_CTRL_R_OPTS=--no-preview
eval $(dircolors "$HOME/.config/dircolors")
export QT_STYLE_OVERRIDE='kvantum'

export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"

[[ -f ~/.bashrc ]] && . ~/.bashrc
