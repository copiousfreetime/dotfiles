# .aliases

# setup aliases
#---------------
alias ..='cd ..'
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
alias b='cd $OLDPWD'
alias c='clear'
alias du='/usr/bin/du -h'
alias find='/usr/bin/find'

alias l.='/bin/ls -lFdh .*'
alias ls='/bin/ls -F'
alias ll='/bin/ls -lFh'
alias la='/bin/ls -laFh'
alias lrt='/bin/ls -lrtFh'
alias lart='/bin/ls -lartFh'

alias pd='pushd'
alias pp='popd'

alias show='set | grep'
alias sudo='/usr/bin/sudo -p "[sudo] password for %u: "'

alias keyboard='ioreg -n IOHIDKeyboard -r | grep -e "class IOHIDKeyboard" -e VendorID\" -e Product'

alias bs='./script/bootstrap'

# use to turn wi-fi on and off
# `wifi on` and `wifi off`
alias wifi='networksetup -setairportpower en0'

# open a file using the Marked application
alias marked='open -a Marked'

# iso8601 Date
alias idate='date -u +"%Y-%m-%dT%H:%M:%SZ"'

# vim sub commands
alias v=nvim
alias vim=nvim

# -- other -- #
alias tmux="TERM=screen-256color-bce tmux"
alias myip='curl ifconfig.co'

# search for system icons
function icons {
  find /System/Library -iname '*.icns' -o -iname '*.tiff' -o -iname '*.png' 2>/dev/null | grep -i "$1[^/]*$"
}

function ql {
  qlmanage -p "$@" & pid=$!
  read -sn1
  kill $pid; wait $pid
} 2>/dev/null

function psg {
  ps wwwaux | egrep "($1|%CPU)" | grep -v grep
}

function p {
  if [ -n "$1" ]; then
    ps -O ppid -U $USER | grep "$1" | grep -v grep
  else
    ps -O ppid -U $USER
  fi
}

function pkill {
  if [ -z "$1" ]; then
    echo "Usage: pkill [process name]"
    return 1
  fi

  local pid
  pid=$(p $1 | awk '{ print $1 }')

  if [ -n "$pid" ]; then
    echo -n "Killing \"$1\" (process $pid)..."
    kill -sigkill $pid
    echo "done."
  else
    echo "Process \"$1\" not found."
  fi
}

function pint {
  if [ -z "$1" ]; then
    echo "Usage: pint [process name]"
    return 1
  fi

  local pid
  pid=$(p $1 | awk '{ print $1 }')

  if [ -n "$pid" ]; then
    echo -n "Sending INT to \"$1\" (process $pid)..."
    kill -sigint $pid
    echo "done."
  else
    echo "Process \"$1\" not found."
  fi
}

function findr {
  find . -name '*.rb' -print0 | xargs -0 grep "$*"
}

function cdiff {
  diff -c "$1" "$2" 2>&1 | awk -f "$DOTS/bash/cdiff.awk"
}

# from Nathan Witmer
alias scan-ssh='dns-sd -B _ssh._tcp'

function ssh-setup {
  ssh $1 'mkdir -p -m 700 .ssh; touch .ssh/authorized_keys; chmod 600 .ssh/authorized_keys';
  cat ~/.ssh/id_rsa.pub | ssh $1 'cat - >> ~/.ssh/authorized_keys'
}

# Enable a yubikey via the yubiswitch application if it is installed
function enable-yubikey() {
  ps ux | grep [y]ubiswitch >/dev/null && osascript -e 'tell application "yubiswitch" to KeyOn'
}

