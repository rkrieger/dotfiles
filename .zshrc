#
# .zshrc
#
# @author Rogier Krieger
#

# Preferred basic utilities
export VISUAL=vi
export EDITOR=vi
export PAGER=less
export LANG=en_US.UTF-8
export LC_CTYPE=C

# Custom $PATH
export PATH=${HOME}/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"

# Simple prompt
export PS1='%n@%m:%~%# '
set -o emacs

# Aliases (if present)
if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

# Auto-update homebrew upon usage (weekly)
export HOMEBREW_AUTO_UPDATE_SECS=604800


# Docker utility functions (from geerlingguy)
# Usage: dockrun, or dockrun [centos7|fedora27|debian9|debian8|ubuntu1404|etc.]
dockrun() {
  docker run -it rkrieger/docker-"${1:-debian11}"-ansible /bin/bash
}

# Enter a running Docker container.
function denter() {
  if [[ ! "$1" ]] ; then
    echo "You must supply a container ID or name."
    return 0
  fi

  docker exec -it $1 bash
  return 0
}


# Delete known_hosts entries by line
knownrm() {
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    echo "error: line number missing" >&2;
  else
    sed -i '' "$1d" ~/.ssh/known_hosts
  fi
}


# Paste input for easy sharing
6p() {
  curl -s -F "content=<${1--}" -F ttl=604800 -w "%{redirect_url}\n" -o /dev/null \
   https://p.vnode.net/
}

pscreen() {
  local _date=$(date '+%Y%m%d-%H%M%S')
  local _temp=$(mktemp /tmp/screenshot-${_date}.XXXXX.png)
  pngpaste ${_temp}
  6p ${_temp}
  rm -rf ${_temp}
}


# Generate convenience passwords
genpass() {
  openssl rand 5 | openssl sha256 -binary | openssl base64 | cut -c16-32;
}


# Update ssh-agent credentials for re-attached tmux session
agent() {
  eval $(tmux showenv -s SSH_AUTH_SOCK);
}
