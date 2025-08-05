export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export MANPAGER="nvim +Man!"
export TERMINAL="foot"
export BROWSER="qutebrowser"
export GPG_TTY=$(tty)
export GOPATH="$XDG_DATA_HOME/go"

export PATH=~/.local/bin:$PATH
export PATH=$GOPATH/bin:$PATH

export BAT_THEME="base16"
export FZF_DEFAULT_OPTS="--info hidden \
--color=fg:#e2e3d8,bg:#12140e,hl:#b1d18a \
--color=fg+:#e2e3d8,bg+:#282b24,hl+:#b1d18a \
--color=info:#c5c8ba,prompt:#b1d18a,pointer:#b1d18a \
--color=marker:#cdeda3,spinner:#bfcbad,header:#bfcbad \
--color=border:#8f9285"
eval $(dircolors "$HOME/.config/dircolors")
export QT_STYLE_OVERRIDE='kvantum'

[[ -f ~/.bashrc ]] && . ~/.bashrc
