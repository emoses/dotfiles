# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

export EDITOR=vi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)

source /usr/local/git/contrib/completion/git-completion.bash
source /usr/local/git/contrib/completion/git-prompt.sh

export LSCOLORS=GxFxCxDxBxegedabagaced
PS1='\[\033[38;5;113m\]\u@\h\[\033[00m\]:\[\033[01;36m\]$(__git_ps1 " %s") \[\033[00m\]\[\033[38;5;26m\]\W\[\033[00m\]\$ '

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    #eval "`dircolors -b`"
    alias ls='ls -G'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias ccHead='ccollab addgitdiffs new HEAD^ HEAD'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#matrix stuff
export MATRIX_HOME=$HOME/dev/sfdc-matrix
export GRADLE_HOME=$MATRIX_HOME/tools/gradle-1.11
export STORM_HOME=$MATRIX_HOME/tools/apache-storm-0.9.1-incubating
export KAFKA_HOME=$MATRIX_HOME/tools/kafka_2.8.0-0.8.0
export SCALA_HOME=$HOME/dev/scala
export PATH=$PATH:$STORM_HOME/bin:$GRADLE_HOME/bin:$HOME/Library/Haskell/bin:$SCALA_HOME/bin
#export LD_LIBRARY_PATH=$ORACLE_HOME/client/lib

#for dev
#export DEV_HOME=$HOME/blt

export MATRIX_DEFAULT_PROJECT=keymaker
source $MATRIX_HOME/developer-tools/scripts/dev.sh

#n () {
#    $* && notify-send -i face-cool "$* successful." || notify-send -i face-sad "$* failed."
#}

#if [[ "$SSH_ORIGINAL_COMMAND" == "/usr/NX/bin/nxnode" ]]; then
#    xmodmap $HOME/.Xmodmap
#fi
