export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export MANPAGER="nvim +Man!"
export TERMINAL="footclient"
export BROWSER="qutebrowser"
export GPG_TTY=$(tty)
export GOPATH="$XDG_DATA_HOME/go"

export PATH=~/.local/bin:$PATH
export PATH=$GOPATH/bin:$PATH

export BAT_THEME="base16"
export FZF_DEFAULT_OPTS="--info hidden \
--color=bg+:#2e2e2e,bg:#161616,spinner:#be95ff,hl:#ff8389 \
--color=fg:#ffffff,header:#be95ff,pointer:#be95ff \
--color=marker:#ab8600,fg+:#ffffff,prompt:#78a9ff,hl+:#ff8389 \
--color=selected-bg:#383838 \
--color=border:#2e2e2e,label:#ffffff"
eval $(dircolors "$HOME/.config/dircolors")
export QT_STYLE_OVERRIDE='kvantum'

[[ -f ~/.bashrc ]] && . ~/.bashrc
