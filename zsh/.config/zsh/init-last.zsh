# ══════════════════════════════════════════════════════════════════════
#  Ordering-sensitive shell initializers.
#
#  THIS FILE MUST BE SOURCED LAST in .zshrc — after oh-my-zsh, after
#  any prompt framework, after every plugin.
#
#  Why it is a separate file: zoxide asserts that nothing mutates
#  precmd after it, so it has to init absolutely last. That constraint
#  used to live in a comment at the bottom of .zshrc, where an ML4W
#  update overwriting .zshrc would silently lose it. Keeping it in its
#  own file makes the ordering structural instead of advisory.
#
#      source ~/.config/zsh/init-last.zsh   # very bottom of .zshrc
# ══════════════════════════════════════════════════════════════════════

# _ZO_DOCTOR=0 suppresses zoxide's precmd-hook order warning. We run
# zoxide last on purpose, but oh-my-zsh plugins still touch hooks.
export _ZO_DOCTOR=0

command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# starship: prompt (overrides any framework theme if installed)
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# atuin: searchable, sync-capable shell history. Replaces Ctrl-R.
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"

# zoxide: smarter cd — keep absolute last
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
