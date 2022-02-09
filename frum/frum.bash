FRUM=/opt/homebrew/bin/frum

if [ -e $FRUM ]; then
  export FRUM_DIR=/opt/frum
  eval "$(frum init)"
fi
