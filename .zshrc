# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="kolo"
HADOOP_HOME="/Users/mike/Downloads/hadoop-0.20.2-cdh3u4"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias duf='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias f='find . -name'
alias mvim='/Users/mike/Downloads/MacVim-snapshot-62/mvim'
alias fvim='~/fvim.sh'
alias lessc="/Users/mike/node_modules/less/bin/lessc"
alias sshwhr="/Users/mike/sshwhr.sh"
alias sshwhrh="/Users/mike/sshwhrh.sh"
alias cdm='cd /Users/mike/homebrew/Cellar/mongodb/2.2.0-rc0-x86_64/bin'
alias pretty='python -mjson.tool'
alias ec2ssh='ssh -i /Users/mike/projects/ops/ec2/noc-admin/id_rsa-kp1'
alias pgrep="ps -axo pid,command,args | grep -i '$@' | awk '{ print $1 }'"
alias t="/Users/mike/Downloads/ginatrapani-todo.txt-cli-137140a/todo.sh"
alias jsoncurl="python -i /Users/mike/projects/jsoncurl.py"
alias teaminal="python /Users/mike/projects/screenpals/sharepty.py"
#alias md2html="python -c 'import sys; from markdown import Markdown; m = Markdown(); html= m.convert(sys.stdin.read().encode(\"utf-8\")); print html'"
alias md2html="/Users/mike/md2html.py"


# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx python heroku)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/Users/mike/node_modules/less/bin/:/opt/local/bin:/opt/local/sbin:/Users/mike/bin:/usr/local/bin:/usr/local/mysql/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/Users/mike/homebrew/bin:/Users/mike/homebrew/Cellar/node/0.4.12/bin

# set up an alias to the codereview uploader, change paths on your system where applicable
alias cr python ~/Downloads/upload.py \-y \-s codereview.10gen.com \-m

export PATH="$PATH:$HADOOP_HOME/bin"
export JAVA_HOME=$(/usr/libexec/java_home)


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
