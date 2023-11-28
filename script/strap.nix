#!/bin/bash
#/ Usage: strap.nix [--debug]
#/ Install development dependencies for *nix systems.

set -e

[[ "$1" == "--debug" || -o xtrace ]] && STRAP_DEBUG="1"
STRAP_SUCCESS=""

ask_for

sudo_askpass() {
  if [ -n "$SUDO_ASKPASS" ]; then
    sudo --askpass "$@"
  else
    sudo "$@"
  fi
}

cleanup() {
  set +e
  sudo_askpass rm -rf "$CLT_PLACEHOLDER" "$SUDO_ASKPASS" "$SUDO_ASKPASS_DIR"
  sudo --reset-timestamp
  if [ -z "$STRAP_SUCCESS" ]; then
    if [ -n "$STRAP_STEP" ]; then
      echo "!!! $STRAP_STEP FAILED" >&2
    else
      echo "!!! FAILED" >&2
    fi
    if [ -z "$STRAP_DEBUG" ]; then
      echo "!!! Run '$0 --debug' for debugging output." >&2
      echo "!!! If you're stuck: file an issue with debugging output at:" >&2
      echo "!!!   $STRAP_ISSUES_URL" >&2
    fi
  fi
}

trap "cleanup" EXIT

if [ -n "$STRAP_DEBUG" ]; then
  set -x
else
  STRAP_QUIET_FLAG="-q"
  Q="$STRAP_QUIET_FLAG"
fi

STDIN_FILE_DESCRIPTOR="0"
[ -t "$STDIN_FILE_DESCRIPTOR" ] && STRAP_INTERACTIVE="1"


# We want to always prompt for sudo password at least once rather than doing
# root stuff unexpectedly.
sudo --reset-timestamp

# functions for turning off debug for use when handling the user password
clear_debug() {
  set +x
}

reset_debug() {
  if [ -n "$STRAP_DEBUG" ]; then
    set -x
  fi
}

# Initialise (or reinitialise) sudo to save unhelpful prompts later.
sudo_init() {
  if [ -z "$STRAP_INTERACTIVE" ]; then
    return
  fi

  # If TouchID for sudo is setup: use that instead.
  if grep -q pam_tid /etc/pam.d/sudo; then
    return
  fi

  local SUDO_PASSWORD SUDO_PASSWORD_SCRIPT

  if ! sudo --validate --non-interactive &>/dev/null; then
    while true; do
      read -rsp "--> Enter your password (for sudo access):" SUDO_PASSWORD
      echo
      if sudo --validate --stdin 2>/dev/null <<<"$SUDO_PASSWORD"; then
        break
      fi

      unset SUDO_PASSWORD
      echo "!!! Wrong password!" >&2
    done

    clear_debug
    SUDO_PASSWORD_SCRIPT="$(cat <<BASH
#!/bin/bash
echo "$SUDO_PASSWORD"
BASH
)"
    unset SUDO_PASSWORD
    SUDO_ASKPASS_DIR="$(mktemp -d)"
    SUDO_ASKPASS="$(mktemp "$SUDO_ASKPASS_DIR"/strap-askpass-XXXXXXXX)"
    chmod 700 "$SUDO_ASKPASS_DIR" "$SUDO_ASKPASS"
    bash -c "cat > '$SUDO_ASKPASS'" <<<"$SUDO_PASSWORD_SCRIPT"
    unset SUDO_PASSWORD_SCRIPT
    reset_debug

    export SUDO_ASKPASS
  fi
}

sudo_refresh() {
  clear_debug
  if [ -n "$SUDO_ASKPASS" ]; then
    sudo --askpass --validate
  else
    sudo_init
  fi
  reset_debug
}

abort() { STRAP_STEP="";   echo "!!! $*" >&2; exit 1; }
log()   { STRAP_STEP="$*"; sudo_refresh; echo "--> $*"; }
logn()  { STRAP_STEP="$*"; sudo_refresh; printf -- "--> %s " "$*"; }
logk()  { STRAP_STEP="";   echo "OK"; }
escape() {
  printf '%s' "${1//\'/\'}"
}

[ "$USER" = "root" ] && abort "Run Strap as yourself, not root."
groups | grep $Q -E "\b(wheel)\b" || abort "Add $USER to the wheel group."

# Setup Git configuration.
logn "Configuring Git:"
read -p "What is your git name: " STRAP_GIT_NAME
read -p "What is your git email: " STRAP_GIT_EMAIL
read -p "What is your github username: " STRAP_GITHUB_USER


if [ -n "$STRAP_GIT_NAME" ] && ! git config user.name >/dev/null; then
  git config --global user.name "$STRAP_GIT_NAME"
fi

if [ -n "$STRAP_GIT_EMAIL" ] && ! git config user.email >/dev/null; then
  git config --global user.email "$STRAP_GIT_EMAIL"
fi

if [ -n "$STRAP_GITHUB_USER" ] && [ "$(git config github.user)" != "$STRAP_GITHUB_USER" ]; then
  git config --global github.user "$STRAP_GITHUB_USER"
fi

# Squelch git 2.x warning message when pushing
if ! git config push.default >/dev/null; then
  git config --global push.default simple
fi
logk

# Setup dotfiles
if [ -n "$STRAP_GITHUB_USER" ]; then
  DOTFILES_URL="https://github.com/$STRAP_GITHUB_USER/dotfiles"

  if git ls-remote "$DOTFILES_URL" &>/dev/null; then
    log "Fetching $STRAP_GITHUB_USER/dotfiles from GitHub:"
    if [ ! -d "$HOME/.dotfiles" ]; then
      log "Cloning to ~/.dotfiles:"
      git clone $Q "$DOTFILES_URL" ~/.dotfiles
    else
      (
        cd ~/.dotfiles
        git pull $Q --rebase --autostash
      )
    fi
    logk
  fi
fi

## Install all the dotfiles
(
cd ~/.dotfiles
rake base16:install vim:install install
)

## isntall vim


