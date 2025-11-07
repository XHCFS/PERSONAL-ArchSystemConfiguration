export PATH="$HOME/.local/bin:$PATH"
source /home/saif/.zsh/zsh-syntax-highlighting.zsh
export VISUAL=nvim;
export EDITOR=nvim;
autoload -U colors && colors
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#e5e9f0,bg:#2E3440,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#A3BE8C
   --color=marker:#a3be8b,spinner:#b48dac,header:#A3BE8C'

# Base16 Solarized Dark
# Scheme author: Ethan Schoonover (modified by aramisgithub)
# Template author: Tinted Theming (https://github.com/tinted-theming)

#_gen_fzf_default_opts() {
#
#local color00='#002b36'
#local color01='#073642'
#local color02='#586e75'
#local color03='#657b83'
#local color04='#839496'
#local color05='#93a1a1'
#local color06='#eee8d5'
#local color07='#fdf6e3'
#local color08='#dc322f'
#local color09='#cb4b16'
#local color0A='#b58900'
#local color0B='#859900'
#local color0C='#2aa198'
#local color0D='#268bd2'
#local color0E='#6c71c4'
#local color0F='#d33682'
#
#export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
#" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
#" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
#" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
#
#}

#_gen_fzf_default_opts
export PATH=~/bin:.:$PATH
#export PATH=~/miniconda3/bin:.:$PATH
bindkey -M vicmd '^X^m' accept-line-swallow # if you're using vim bindings in zsh
bindkey -M viins '^X^m' accept-line-swallow # if you're using vim bindings in zsh
bindkey '^X^m' accept-line-swallow
zle -N accept-line-swallow acceptandswallow
acceptandswallow() {
	dwmswallow $WINDOWID
	zle accept-line
}
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit && compinit
zmodload -i zsh/complist
source /home/saif/.zsh/zsh-syntax-highlighting.zsh
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export SAVEHIST=10000000000
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "

setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
autoload -Uz history-beginning-search-menu
zle -N history-beginning-search-menu
bindkey '^X^X' history-beginning-search-menu
source /home/saif/.zsh/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
autoload -U compinit; compinit
alias torrent="transmission-daemon && transmission-remote -a"
alias torrstat="transmission-remote -l"
#export LIBVA_DRIVER_NAME="nvidia"

alias config='/usr/bin/git --git-dir=$HOME/PERSONAL-ArchSystemConfiguration/ --work-tree=$HOME'

zstyle ':completion:*' group-name ''
pfetch
export PATH=$PATH:/usr/lib/qt6/bin
setopt auto_cd

alias dvdcss="cd ~/GSoC/forked_dvd_libraries/libdvdcss/"
alias dvdread="cd ~/GSoC/forked_dvd_libraries/libdvdread/"
alias dvdvlc="cd ~/GSoC/vlc/ && nvim modules/access/dvdread.c"
alias project_vlc="cd ~/GSoC/vlc/"

# USE LF TO SWITCH DIRECTORIES AND BIND IT TO CTRL-O
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^[o' 'lfcd\n'

if [ -z "$TMUX" ]; then
    tmux new-session -s tmux_$(date +%s)
fi
eval "$(zoxide init zsh)"
