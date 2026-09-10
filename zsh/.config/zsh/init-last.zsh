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

# ── Prompt ────────────────────────────────────────────────────────────
# ML4W's 20-customization already initializes oh-my-posh. This file is
# sourced after it (via ~/.zshrc_custom), so whatever runs here wins.
#
# Set ZSH_PROMPT=ohmyposh to keep ML4W's prompt instead of starship.
: "${ZSH_PROMPT:=starship}"

if [[ "$ZSH_PROMPT" == "starship" ]] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# ── fzf ───────────────────────────────────────────────────────────────
# ML4W also sources `fzf --zsh`. Only init if its widgets are absent, so
# this is a no-op under ML4W and still works on a bare system.
if command -v fzf >/dev/null 2>&1 && ! (( ${+widgets[fzf-history-widget]} )); then
    source <(fzf --zsh)
fi

# atuin: searchable, sync-capable shell history. Replaces Ctrl-R.
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"

# zoxide: smarter cd — keep absolute last
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
