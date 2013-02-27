alias please='sudo'
alias plz='sudo'
alias ls='ls -G'

#SVN util
alias pp='python -mjson.tool'


           #'\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\]'
export PS1='\u@\h \[\033[1;33m\]\w\[\033[0m\]$(parse_git_branch)$ '



        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
 LIGHT_BLUE="\[\033[01;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 #COLOR_NONE="\[\e[0m\]"
 COLOR_NONE="\[\033[00m\]"

function test_colors {
    echo -e "${RED}testing${COLOR_NONE}"
    echo -e "${YELLOW}testing${COLOR_NONE}"
    echo -e "${GREEN}testing${COLOR_NONE}"
    echo -e "${BLUE}testing${COLOR_NONE}"
    echo -e "${LIGHT_BLUE}testing${COLOR_NONE}"
    echo -e "${LIGHT_RED}testing${COLOR_NONE}"
    echo -e "${LIGHT_GREEN}testing${COLOR_NONE}"
    echo -e "${WHITE}testing${COLOR_NONE}"
    echo -e "${LIGHT_GRAY}testing${COLOR_NONE}"
    #COLOR_NONE="\[\e[0m\]"
}


function parse_git_branch {
    git rev-parse --git-dir &> /dev/null
    git_status="$(git status 2> /dev/null)"
    branch_pattern="^# On branch ([^${IFS}]*)"
    remote_pattern="# Your branch is (.*) of"
    diverge_pattern="# Your branch and (.*) have diverged"
    if [[ ! ${git_status}} =~ "working directory clean" ]]; then
        state="${RED}¿"
    fi
    # add an else if or two here if you want to get more specific
    if [[ ${git_status} =~ ${remote_pattern} ]]; then
        if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
            remote="${YELLOW}¿"
        else
            remote="${YELLOW}¿"
        fi
    fi
    if [[ ${git_status} =~ ${diverge_pattern} ]]; then
        remote="${YELLOW}¿"
    fi
    if [[ ${git_status} =~ ${branch_pattern} ]]; then
        branch=${BASH_REMATCH[1]}
        echo " (${branch})${remote}${state}"
    fi
}

function parse_git_dirty {
  #git diff --quiet || echo " *"
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch {
  #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
  #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"

}

function stoppedjobs {
    MYVAR=`jobs -s | wc -l | sed -e "s/ //g"`
    if [ "$MYVAR" -eq 0 ]; then
        ''
    else 
        echo "${RED}[$MYVAR] "
    fi
}
 
function prompt_func() {
    #NUMJOBS=stoppedjobs
    prompt="${TITLEBAR}${LIGHT_GREEN}\u@\h${RED} ${LIGHT_BLUE}\w${LIGHT_GREEN}$(parse_git_branch)${RED} ${BLUE}\$${COLOR_NONE} "
    PS1="${prompt}"
}
 
PROMPT_COMMAND=prompt_func

#OLD PS1: \[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\]

# Set standard CLASSPATH
if [ -f /usr/local/util/conf/classpath.sh ]; then
	. /usr/local/util/conf/classpath.sh
	export CLASSPATH=.:$CLASSPATH
fi

[[ -f /etc/profile.d/bash-completion ]] && source /etc/profile.d/bash-completion

umask 002
#export ANT_ARGS="-logger org.apache.tools.ant.listener.AnsiColorLogger"
export ANT_ARGS=""
export EDITOR=vim
