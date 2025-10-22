if [[ -f $HOMEBREW_ROOT/opt/chruby/share/chruby/chruby.sh ]]; then
  echo "Using chruby"
  source $HOMEBREW_ROOT/opt/chruby/share/chruby/chruby.sh
  chruby 3.4.5
fi
