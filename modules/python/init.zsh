#
# Enables local Python package installation.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Sebastian Wiesner <lunaryorn@googlemail.com>
#

# Load manually installed pyenv into the shell session.
if [[ -s "$HOME/.pyenv/bin/pyenv" ]]; then
  path=("$HOME/.pyenv/bin" $path)
  eval "$(pyenv init -)"

# Load package manager installed pyenv into the shell session.
elif (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"

# Prepend PEP 370 per user site packages directory, which defaults to
# ~/Library/Python on Mac OS X and ~/.local elsewhere, to PATH.
else
  if [[ "$OSTYPE" == darwin* ]]; then
    # Prepend /usr/local/share/python{3} to PATH for Hombrew'd Python
    # see: https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python
    if [[ -f /usr/local/bin/python3 ]]; then
      path=(/usr/local/share/python3 $path)
    elif [[ -f /usr/local/bin/python ]]; then
      path=(/usr/local/share/python $path)
    else
      path=($HOME/Library/Python/*/bin(N) $path)
    fi
  else
    # This is subject to change.
    path=($HOME/.local/bin $path)
  fi
fi

# Return if requirements are not found.
if (( ! $+commands[python] && ! $+commands[pyenv] )); then
  return 1
fi

# Load virtualenvwrapper into the shell session.
if (( $+commands[virtualenvwrapper_lazy.sh] )); then
  # Set the directory where virtual environments are stored.
  export WORKON_HOME="$HOME/.virtualenvs"

  # Disable the virtualenv prompt.
  VIRTUAL_ENV_DISABLE_PROMPT=1

  source "$commands[virtualenvwrapper_lazy.sh]"
fi

#
# Aliases
#

alias py='python'

