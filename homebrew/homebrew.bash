BREW_PREFIX=$(brew --prefix)

if [ -f ${BREW_PREFIX}/etc/bash_completion ]; then
   .  ${BREW_PREFIX}/etc/bash_completion
fi

