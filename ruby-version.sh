################################################################################
# name: ruby-version
# what: function that allows switching between compiled ruby versions
# why : there is nothing wrong with trying to keep it simple...
################################################################################

function ruby-version {
  local PROGRAM_APPNAME='ruby-version'
  local PROGRAM_VERSION=0.0.1

  # correct # of arguments?
  if [ $# != 1 ]; then
    echo "ruby-version ${PROGRAM_VERSION}" >&2
    echo ""                                >&2
    echo "Usage  : ruby-version <version>" >&2
    echo "Example: ruby-version 1.9.3-rc1" >&2
    return 1
  fi

  # local variables
  local _RUBY_VERSION=$1
  local _RUBY_VERSIONS=${RUBY_VERSIONS-''}
  local _RUBY_ROOT=${_RUBY_VERSIONS}/${_RUBY_VERSION}

  # bail-out if _RUBY_VERSIONS does not exist
  if [[ ! -d ${_RUBY_VERSIONS} ]]; then
    echo "Sorry, but ${PROGRAM_APPNAME} requires that \$RUBY_VERSIONS is set and points to an existing directory." >&2
    return 1
  fi

  # bail-out if _RUBY_ROOT does not exist
  if [[ ! -d $_RUBY_ROOT ]]; then
    echo "Sorry, but ${PROGRAM_VERSION} was unable to find directory '${_RUBY_VERSION}' under '${_RUBY_VERSIONS}'." >&2
    return 1
  fi

  # it is now safe to export these
  export RUBY_VERSION=${_RUBY_VERSION}
  export RUBY_ROOT=${_RUBY_ROOT}

  # update binary search path
  export PATH="${RUBY_ROOT}/bin:$PATH"

  # add current version's manual pages directory to $MANPATH if it exists
  if [ -d ${RUBY_ROOT}/share/man ]; then
    export MANPATH="${RUBY_ROOT}/share/man:$MANPATH"
  fi

  echo "SWITCHED RUBY VERSION TO: ${RUBY_VERSION}"
  echo "NEW RUBY ROOT DIRECTORY : ${RUBY_ROOT}"
}


################################################################################
# shell completion for ruby-version function
################################################################################

if [[ ! -d ${RUBY_VERSIONS} ]]; then
  echo "Sorry, but ruby-version requires that the environment variable \$RUBY_VERSIONS is set in order to initialize bash completion." >&2
  return 1
fi

if [[ ! -z ${RUBYVERSION_DISABLE_COMPLETE} ]]; then
  return 1
fi

# for bash
if [[ -n ${BASH_VERSION-""} ]]; then
  complete -W "$(echo $(find ${RUBY_VERSIONS} -d -maxdepth 1 | sed -e "s@${RUBY_VERSIONS}[/]*@@" | grep -v '^$'))" ruby-version
fi

