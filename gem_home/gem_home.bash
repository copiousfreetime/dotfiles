if [[ "$(type -t gem_home)" != 'function' ]]; then
  source ${DOTS}/gem_home/_gem_home
fi

if [[ "$(type -t chruby)" != 'function' ]]; then
  source ${DOTS}/chruby/chruby.bash
fi

function rh() {
  local dir version
  dir="$PWD/"
  dir="${dir%/*}"

  version_file="${dir}/.ruby-version"

  if [[ -f "${version_file}" ]]; then
    read -r version < "${version_file}"
    echo "Using ruby version $version"
    chruby ${version}
  else
    echo "$PWD/.ruby-version not found"
  fi

  gem_home .
}
