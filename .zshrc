unsetopt PROMPT_SP
# ==========================================
# 0. INSTANT TMUX START (MUST BE TOP)
# ==========================================
# Executes tmux immediately to avoid double-loading zsh config.
if [ -z "$TMUX" ]; then
    if command -v tmux &> /dev/null; then
        # Create unique session based on time to avoid mirroring
        exec tmux new-session -s "tmux_$(date +%s)"
    fi
fi

# ==========================================
# 1. SETTINGS & FIXES
# ==========================================
# Fix the inverted '%' appearing at startup/end of output
unsetopt PROMPT_SP

export PATH="$HOME/.local/bin:$HOME/bin:/usr/lib/qt6/bin:$PATH"
export VISUAL=nvim
export EDITOR=nvim

# History
export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=10000000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt AUTO_CD

# ==========================================
# 2. PROMPT (STARSHIP)
# ==========================================
# Initialize Starship (High performance, Git-aware prompt)
# Replaces manual PS1 configuration
eval "$(starship init zsh)"

# ==========================================
# 3. MODERN REPLACEMENTS (EZA & BAT)
# ==========================================
# Use 'bat' as a colorizing pager for man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# 'eza' is a modern replacement for 'ls' with git status and icons
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza --icons --group-directories-first -l'
    alias la='eza --icons --group-directories-first -la'
    alias tree='eza --icons --tree'
else
    # Fallback if eza is not installed
    alias ll='ls -l'
    alias la='ls -la'
fi

alias cat='bat -p' # -p is plain (no grid/headers) for copy-pasting

# ==========================================
# 4. COMPLETION SYSTEM (FAST CACHED)
# ==========================================
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit
zmodload -i zsh/complist

# Aggressive caching for speed
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
compinit -C -d "$HOME/.zcompdump"

# Styling
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# ==========================================
# 5. ALIASES & FUNCTIONS
# ==========================================
alias config='/usr/bin/git --git-dir=$HOME/PERSONAL-ArchSystemConfiguration/ --work-tree=$HOME'
alias torrent="transmission-daemon && transmission-remote -a"
alias torrstat="transmission-remote -l"
alias dvdcss="cd ~/GSoC/forked_dvd_libraries/libdvdcss/"
alias dvdread="cd ~/GSoC/forked_dvd_libraries/libdvdread/"
alias dvdvlc="cd ~/GSoC/vlc/ && nvim modules/access/dvdread.c"
alias project_vlc="cd ~/GSoC/vlc/"

# DWM Swallow Logic
acceptandswallow() {
    [ -n "$WINDOWID" ] && dwmswallow "$WINDOWID"
    zle accept-line
}
zle -N acceptandswallow
bindkey '^X^m' acceptandswallow

# LF Directory Switcher (Ctrl-O)
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

# ==========================================
# 6. SEARCH & NAVIGATION
# ==========================================
# FZF Nord Theme
export FZF_DEFAULT_OPTS='
    --height 40% --layout=reverse --border
    --color=fg:#e5e9f0,bg:#2E3440,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#A3BE8C
    --color=marker:#a3be8b,spinner:#b48dac,header:#A3BE8C'

# Substring Search (Arrow Keys)
source /home/saif/.zsh/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Ctrl-R Telescope Style History
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | awk '!seen[$0]++' | 
    fzf --query="$LBUFFER" --prompt="History > " --preview 'echo {}' --preview-window=down:3:wrap) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=${selected[1]}
    if [ -n "$num" ]; then zle vi-fetch-history -n $num; fi
  fi
  zle reset-prompt
  return $ret
}
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget

# Zoxide (Better cd)
eval "$(zoxide init zsh)"

# ==========================================
# 7. LAZY CONDA (SPEED FIX)
# ==========================================
export PATH="/home/saif/miniconda3/bin:$PATH"

# Only load conda when the user types 'conda'
conda() {
    echo "Initializing Conda..."
    unfunction conda
    # Run the heavy setup script
    if [ -f "/home/saif/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/saif/miniconda3/etc/profile.d/conda.sh"
    else
        eval "$('/home/saif/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    fi
    # Execute the requested command
    conda "$@"
}

# ==========================================
# 8. PLUGINS (LOAD LAST)
# ==========================================
pfetch
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/saif/.zsh/zsh-syntax-highlighting.zsh
