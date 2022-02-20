#
# .zshrc
#
# @author Rogier Krieger
#

# Preferred basic utilities
export EDITOR=mg
export PAGER=less
export VISUAL=mg

# Custom $PATH
export PATH=${HOME}/bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin

# Simple prompt
export PS1='%n@%m:%~%# '

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


# Generate convenience passwords
genpass() {
  openssl rand 5 | openssl sha256 -binary | openssl base64 | cut -c16-32;
}


# Update ssh-agent credentials for re-attached tmux session
agent() {
  eval $(tmux showenv -s SSH_AUTH_SOCK);
}
