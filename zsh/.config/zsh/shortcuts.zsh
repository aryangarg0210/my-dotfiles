# ══════════════════════════════════════════════════════════════════════
#  Shell shortcuts — framework-independent.
#
#  Extracted from the pre-ML4W .zshrc on 2026-09-10 so the shortcuts
#  survive ML4W shipping its own .zshrc.
#
#  Source this from anywhere in your .zshrc. Its companion,
#  init-last.zsh, is ordering-sensitive and MUST be sourced last.
#
#      source ~/.config/zsh/shortcuts.zsh
#      ...
#      source ~/.config/zsh/init-last.zsh   # keep at the very bottom
# ══════════════════════════════════════════════════════════════════════

# ──────────────────────────────────────────────────────────────
# Editors
# ──────────────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim

# ──────────────────────────────────────────────────────────────
# Directory listing (eza / exa / lsd, whichever is present)
# ──────────────────────────────────────────────────────────────
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --no-filesize --color=always --icons=always --no-user'
    alias lt='eza --tree --level=2 --icons'
elif command -v exa >/dev/null 2>&1; then
    # exa is deprecated upstream; consider switching to eza (pacman -S eza)
    alias ls='exa --no-filesize --color=always --icons=always --no-user'
    alias lt='exa --tree --level=2 --icons'
elif command -v lsd >/dev/null 2>&1; then
    alias ls='lsd --color=always --icon=always'
    alias lt='lsd --tree'
fi
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias cd='z'

# ──────────────────────────────────────────────────────────────
# Fuzzy find navigation & nvim editing (fzf + fd + bat)
# fd is used when available (faster than find, respects .gitignore)
# ──────────────────────────────────────────────────────────────
if command -v fd >/dev/null 2>&1; then
    _ff_dirs() {
        fd --type=d --hidden --max-depth=4 \
           --exclude .git --exclude node_modules --exclude target \
           --exclude venv --exclude logs --exclude .cache "$@"
    }
    alias cdh='z $(_ff_dirs . ~ | fzf --height=70% --preview="eza -T --color=always {} 2>/dev/null || ls {}")'
    alias cdf='z $(_ff_dirs . | fzf --height=70% --preview="eza -T --color=always {} 2>/dev/null || ls {}")'
    alias nf='nvim $(_ff_dirs . ~ | fzf)'
    alias codef='code $(_ff_dirs . ~ | fzf)'
else
    alias cdh='z $(find ~ -maxdepth 4 -type d -not -path "*/node_modules*" -not -path "*/.git/*" -not -path "*/logs" -not -path "*/target" -not -path "*/venv" | fzf --height=70% --preview="eza -T --color=always {} 2>/dev/null || ls {}")'
    alias cdf='z $(find . -maxdepth 4 -type d -not -path "*/node_modules*" -not -path "*/.git" -not -path "*/logs" -not -path "*/target" -not -path "*/venv" | fzf --height=70% --preview="eza -T --color=always {} 2>/dev/null || ls {}")'
    alias nf='nvim $(find ~ -maxdepth 4 -type d -not -path "*/node_modules*" -not -path "*/logs" -not -path "*/.git" -not -path "*/target" -not -path "*/venv" | fzf)'
    alias codef='code $(find ~ -maxdepth 4 -type d -not -path "*/node_modules*" -not -path "*/logs" -not -path "*/.git" -not -path "*/target" -not -path "*/venv" | fzf)'
fi
alias ff='nvim $(fzf --preview="bat --color=always --style=numbers {} 2>/dev/null || cat {}")'

# ──────────────────────────────────────────────────────────────
# Git
# ──────────────────────────────────────────────────────────────
alias ga='git add .'
alias gcm='git commit -m'
alias gsw='git switch'
alias gsc='git switch -c'
alias gpush='git push'
alias gpull='git pull'
alias gl='git log --graph --oneline --decorate --all'

# ──────────────────────────────────────────────────────────────
# Zoxide search helpers
# ──────────────────────────────────────────────────────────────
nzo() {
    if command -v zoxide >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1; then
        local dir=$(zoxide query -l | fzf --height=40% --reverse --prompt="🔍 Edit Project > ")
        [ -n "$dir" ] && nvim "$dir"
    else
        echo "zoxide or fzf not found"
    fi
}
zd() {
    if command -v zoxide >/dev/null 2>&1 && command -v fzf >/dev/null 2>&1; then
        local dir=$(zoxide query -l | fzf --height=40% --reverse --prompt="🛸 Jump to > ")
        [ -n "$dir" ] && builtin cd "$dir"  # builtin avoids recursion with cd='z'
    else
        echo "zoxide or fzf not found"
    fi
}

# ──────────────────────────────────────────────────────────────
# GH authentication
# ──────────────────────────────────────────────────────────────
alias ghsw='gh auth switch --user'
alias ghst='gh auth status'

# ──────────────────────────────────────────────────────────────
# Dotfile editing shortcuts
# ──────────────────────────────────────────────────────────────
alias confz='nvim ~/my-dotfiles/zsh/.config/zsh/shortcuts.zsh'
alias confv='nvim ~/my-dotfiles/nvim/.config/nvim/init.lua'
alias conft='nvim ~/my-dotfiles/tmux/.config/tmux/tmux.conf'
# hyprland.lua, not .conf — hyprlang is removed in Hyprland 0.57
alias confh='nvim ~/.config/hypr/hyprland.lua'
# the migration rescue config (see docs/superpowers/specs/)
alias confr='nvim ~/.config/hypr-rescue/hyprland.lua'

# ──────────────────────────────────────────────────────────────
# Basic shortcuts
# ──────────────────────────────────────────────────────────────
alias c='clear'
alias e='exit'
alias h='cd ~'
alias lg='lazygit'
alias n='nvim'
alias t='tmux'
alias tx='tmux-sessionizer'

alias dmu='yt-dlp -x --audio-format mp3'
alias vres='yt-dlp -F'
alias prismlauncher='QT_QPA_PLATFORM=xcb prismlauncher'

# tldr (tealdeer): fast cheatsheet — `tldr tar`, `tldr git rebase`
command -v tldr >/dev/null 2>&1 && alias help='tldr'

# Fuzzy search manual pages — picks from actually-installed man pages
fman() {
    local pick
    pick=$(apropos . 2>/dev/null | fzf --preview='echo {1} | xargs -r man') || return
    man "${pick%% *}"
}

# ──────────────────────────────────────────────────────────────
# History
# ──────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt HIST_IGNORE_ALL_DUPS   # ignore duplicate commands
setopt HIST_REDUCE_BLANKS     # trim unnecessary spaces

# ──────────────────────────────────────────────────────────────
# Toolchain paths
# ──────────────────────────────────────────────────────────────
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# pnpm global bin (idempotent — safe if ML4W's zshrc also adds it)
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ──────────────────────────────────────────────────────────────
# FZF defaults — use fd when available
# ──────────────────────────────────────────────────────────────
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
fi
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {} 2>/dev/null || cat {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} 2>/dev/null | head -200'"
export FZF_TMUX_OPTS=" -p90%,70% "

# ──────────────────────────────────────────────────────────────
# Login greeting
# ──────────────────────────────────────────────────────────────
if command -v pokemon-colorscripts >/dev/null 2>&1; then
    pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -
elif command -v fastfetch >/dev/null 2>&1; then
    fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
fi
