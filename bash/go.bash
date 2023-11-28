
# Setup Go
export GOPATH=$HOME/go
PATH="$PATH:$GOPATH/bin"
if command -v brew; then
  export GOROOT=$(brew --prefix go)/libexec
  PATH="$PATH:$GOROOT/bin"
fi
