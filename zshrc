# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd autopushd extendedglob nohup nomatch
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/david/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

DIRSTACKSIZE=16
case $TERM in
  xterm*)
    precmd () {print -Pn "\e]0;%n@%m: %~\a"}
    ;;
esac

PS1='%n@%m:%32<...<%~%<<%# '

. ~/.profile
# Deduplicate the path
typeset -U path

alias ls='ls --color'

# Load oh-my-zsh
if [ -d $HOME/.oh-my-zsh ] ; then
  ZSH=$HOME/.oh-my-zsh
  ZSH_THEME="matir"
  plugins=(git)
  source $ZSH/oh-my-zsh.sh
fi
