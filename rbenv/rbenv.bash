#!/bin/bash

if [ -f ~/.rbenv/bin/rbenv ]; then
  echo "Using rbenv"
  eval "$(~/.rbenv/bin/rbenv init - bash)"
#else
#  echo "ERROR: rbenv not found!"
#  echo "git clone https://github.com/rbenv/rbenv.git ~/.rbenv"
#  echo 'git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build'
fi

