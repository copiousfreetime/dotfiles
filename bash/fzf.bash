# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
fzf_auto_complete="/opt/homebrew/opt/fzf/shell/completion.bash"
if [[ -f $fzf_auto_complete ]]; then
  source $fzf_auto_complete
fi

# Key bindings
# ------------
fzf_key_bindings="/opt/homebrew/opt/fzf/shell/key-bindings.bash"
if [[ -f $fzf_key_bindings ]]; then
  source $fzf_key_bindings
fi
