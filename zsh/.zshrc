# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# Theme: starship overrides this if installed (eval at bottom of file).
# Kept as fallback when starship is missing.
ZSH_THEME="daveverwer"

# Ported and supercharged Oh-My-Zsh plugins
plugins=(
    git
    archlinux
    web-search
    sudo
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)

source $ZSH/oh-my-zsh.sh

# ──────────────────────────────────────────────────────────────
# Editors
# ──────────────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim

# Display Pokemon-colorscripts with compact fastfetch
if command -v pokemon-colorscripts >/dev/null 2>&1; then
    pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -
elif command -v fastfetch >/dev/null 2>&1; then
    fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
fi

# ──────────────────────────────────────────────────────────────
# Directory Listing (modern alternative with eza / lsd support)
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
# Fuzzy Find Navigation & Nvim Editing (fzf + fd + bat)
# fd is used when available (much faster than find, respects .gitignore)
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
# Modern Git & Switch Aliases
# ──────────────────────────────────────────────────────────────
alias ga='git add .'
alias gcm='git commit -m'
alias gsw='git switch'
alias gsc='git switch -c'
alias gpush='git push'
alias gpull='git pull'
# Premium graph log
alias gl='git log --graph --oneline --decorate --all'

# ──────────────────────────────────────────────────────────────
# Zoxide Search helpers
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
        [ -n "$dir" ] && builtin cd "$dir"  # use builtin to avoid recursion with cd='z' alias
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
# Custom Dotfile Editing Shortcuts (Highly convenient)
# ──────────────────────────────────────────────────────────────
alias confz='nvim ~/my-dotfiles/zsh/.zshrc'
alias confv='nvim ~/my-dotfiles/nvim/.config/nvim/init.lua'
alias conft='nvim ~/my-dotfiles/tmux/.config/tmux/tmux.conf'
alias confh='nvim ~/my-dotfiles/hypr/.config/hypr/hyprland.conf'

# ──────────────────────────────────────────────────────────────
# Basic Linux Shortcuts
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
# (apropos lists everything with a description, with a live man preview).
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

# bun & SDK Paths
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ──────────────────────────────────────────────────────────────
# FZF defaults — use fd when available (much faster, respects .gitignore)
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
# Initializers — order matters. zoxide MUST be absolute-last
# because it asserts no one else mutates precmd after it.
# (_ZO_DOCTOR=0 suppresses the precmd-hook order warning; we run
# zoxide last on purpose, but oh-my-zsh plugins still touch hooks.)
# ──────────────────────────────────────────────────────────────
export _ZO_DOCTOR=0

command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# starship: prompt (overrides Oh-My-Zsh theme if installed)
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# atuin: searchable, sync-capable shell history. Replaces Ctrl-R.
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"

# zoxide: smarter cd — keep absolute last
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# pnpm global bin config
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
