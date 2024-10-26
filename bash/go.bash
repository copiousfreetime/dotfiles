# Setup Go
export GOPATH=$HOME/go
PATH="$PATH:$GOPATH/bin"
if command -v brew > /dev/null; then
  brew_prefix=$(brew --prefix go)
  export GOROOT=${brew_prefix}/libexec
  PATH="$PATH:$GOROOT/bin"
fi
