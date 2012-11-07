# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# dont put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi

_git_status()
{
  # check if we're in a git repository
  if git rev-parse 2> /dev/null; then
    # show if there are changes pending
    if current_git_status=$(git status --porcelain | grep '^ [MD]' 2> /dev/null > /dev/null); then
      PENDING="y"
    fi
    # show if changes have been 'added' for commit
    if current_git_status=$(git status --porcelain | grep '^[MADRC]' 2> /dev/null > /dev/null); then
      STAGED="y"
    fi
    if [ "$PENDING" = "y" ] && [ "$STAGED" = "y" ]; then
        echo -n "◈"
    elif [ "$PENDING" = "y" ]; then
        echo -n "◇"
    elif [ "$STAGED" = "y" ]; then
        echo -n "◆"
    fi
  fi
}

if [ $(id -u) -eq 0 ]; then
    PS1='\[\033[01;31m\]\u\[\033[01;32m\]@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(__git_ps1  " (%s\[$(tput setaf 2)\]\[\033[01;31m\]$(_git_status)\[\033[01;33m\])")\[\033[01;31m\]#\[\033[00m\] '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(__git_ps1 " (%s\[$(tput setaf 2)\]\[\033[01;31m\]$(_git_status)\[\033[01;33m\])")\[\033[01;32m\]\$\[\033[00m\] '
fi

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=always'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=always'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias less='less -R'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -d ~/.bash ];then
    for i in $(ls ~/.bash);do
	. ~/.bash/$i
    done
fi

if [ -d $HOME/.rvm ];then
    export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
    source $HOME/.rvm/scripts/rvm
fi

#synclient TapButton3=3 TapButton2=2
_byobu_sourced=1 . /usr/bin/byobu-launch


if [ -d /usr/lib/jvm ] && [ -d /usr/lib/jvm/java-7-openjdk-amd64 ];then
    export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
    export CLASSPATH=$CLASSPATH:/usr/share/java/log4j-1.2.jar
fi

if [ -d $HOME/opt/ ];then
    if [ -d $HOME/opt/jboss/ ];then
        export JBOSS_HOME=$HOME/opt/jboss/
    fi
    if [ -d $HOME/opt/hadoop/ ];then
        export HADOOP_HOME=~/opt/hadoop/
    fi
    if [ -d $HOME/opt/pig/ ];then
        export PIGDIR=~/opt/pig/
    fi
    if [ -d $HOME/opt/sbt/bin/ ];then
        export PATH=$PATH:$HOME/opt/sbt/bin/
    fi
    if [ -d $HOME/bin/ ];then
        export PATH=$HOME/bin/:$PATH
    fi
fi

#:$HOME/Documents/install/matlab2/bin/

export PATH=$(perl ~/usr/cope/cope_path.pl):$PATH:$HOME/bin

