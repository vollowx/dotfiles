export PATH=$PATH:~/.local/share/bin
export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'
export MANPAGER='nvim +Man!'
export TERMINAL='foot'
export BROWSER='qutebrowser'
export GPG_TTY=$(tty)
export BAT_THEME='base16'
export QT_STYLE_OVERRIDE='kvantum'
eval $(dircolors "$HOME/.config/dircolors")

if [[ -f ~/.bashrc ]]; then
  . ~/.bashrc
fi
