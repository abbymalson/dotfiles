# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# Update window size.
shopt -s checkwinsize
shopt -s histappend 

# https://www.digitalocean.com/community/tutorials/how-to-use-bash-history-commands-and-expansions-on-a-linux-vps
# History Sizes
HISTSIZE=5000
HISTFILESIZE=10000

# Bash specific functions 
[ -f "$HOME/.bash_functions_colors" ] && . "$HOME/.bash_functions_colors"
[ -f "$HOME/.bash_functions_git" ] && . "$HOME/.bash_functions_git"
[ -f "$HOME/.bash_functions_calendar" ] && . "$HOME/.bash_functions_calendar"
[ -f "$HOME/.bash_functions_weedmaps" ] && . "$HOME/.bash_functions_weedmaps"
[ -f "$HOME/.bash_functions_docker" ] && . "$HOME/.bash_functions_docker"
[ -f "$HOME/.bash_functions_tail" ] && . "$HOME/.bash_functions_tail"
[ -f "$HOME/.bash_functions" ] && . "$HOME/.bash_functions"

#
# PROMPT
#

if [[ "$TERM" =~ .*-256color ]]; then
    icon_commit='➦'
    icon_branch='|>'
    icon_separator=''
else
    icon_commit='c:'
    icon_branch='b:'
    icon_separator=''
fi

PROMPT_COMMAND='set_prompt'

# https://www.digitalocean.com/community/tutorials/how-to-use-bash-history-commands-and-expansions-on-a-linux-vps

# Adding shared history support -- multiple terminals (useful for tmux/screen)
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

#
# ALIASES
#

PS1=""

# Linux specific setup.
if [ $(uname) == 'Linux' ]; then
  [ -f "$HOME/.bash_aliases_linux" ] && . "$HOME/.bash_aliases_linux"
fi
if [ $(uname) == 'CYGWIN_NT-10.0' ]; then
  [ -f "$HOME/.bash_aliases_cygwin" ] && . "$HOME/.bash_aliases_cygwin"
fi

# Mac OS X specific setup.
if [ $(uname) == 'Darwin' ]; then
  [ -f "$HOME/.bash_aliases_darwin" ] && . "$HOME/.bash_aliases_darwin"
fi

#
# SSH
#

# Setup SSH agent.
if [ -n "$SSH_TTY" ]; then
    SSH_ENV=~/.ssh/environment

    function start_agent {
        echo "Initializing new SSH agent..."
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
        ssh-add
    }

    # Source SSH settings, if applicable.
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
            start_agent
        }
    else
        start_agent
    fi
fi

#
# GIT
#

# Git paging.
export GIT_PAGER='less -+$LESS -FXR'

# Git auto completion.
if [ -n "$BASH_VERSION" ]; then
    . ~/.git-completion.bash
fi

#
# PATHS
#

export PATH="~/code/weedmaps_code/weedmaps-tools/git:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export GIT_EXEC_PATH="/usr/libexec/git-core/"
# Add user binary path.
[ -d "$HOME/bin" ] && export PATH="$PATH:$HOME/bin"
# Add RVM to path.
[ -f "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"

#
# OTHER
#

# Allow server-specific scripting.
[ -f "$HOME/.bash_custom" ] && . "$HOME/.bash_custom"
[ -f "$HOME/.bash_alias" ] && . "$HOME/.bash_alias"

# Bash specific aliases
[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"

# Node Virtual Machine
if hash brew 2>/dev/null; then
  export NVM_DIR="$HOME/.nvm"
  source $(brew --prefix nvm)/nvm.sh
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
fi

#source ~/liquidprompt/liquidprompt
# vim:: set ft=sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
