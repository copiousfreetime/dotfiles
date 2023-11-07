
# Setup Go
export GOPATH=$HOME/go
export GOROOT=$(brew --prefix go)/libexec
if [ -d "$GOPATH/bin" ] ; then
  PATH="$PATH:$GOPATH/bin"
  PATH="$PATH:$GOROOT/bin"
fi
