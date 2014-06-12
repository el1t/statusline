# BACKUP COPY—replaced sensitive strings
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh


# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnostermod"

# Example aliases
alias zshconfig="st ~/.zshrc"
alias ohmyzsh="stt ~/.oh-my-zsh"
alias zsource="source ~/.zshrc"
alias clr="rm /Users/El1t/.zsh_history;tab;exit"
alias py="python3"
alias csl="ssh -t user_name@host ssh\ $(gshuf -n 1 -e xilonen tlaloc teteoinnan)"
# alias csps="ssh -t user_name@host \"ssh -t $(gshuf -n 1 -e xilonen tlaloc teteoinnan) 'lpstat -a'\""
alias printers="lpstat -a"
hash -d AI=~/Documents/School/AI
hash -d repo=~/Documents/Git
hash -d school=~/Documents/School
hash -d trash=~/.Trash

cspr() {
	local printer=accepting
	if [[ -n $1 ]]; then
		if [[ $1 -eq '-help' ]]; then
			echo "usage: cspr [printer]"
			return
		fi
		printer=$1
	fi
	ssh -t user@host "ssh -t $(gshuf -n 1 -e xilonen tlaloc teteoinnan) 'lpstat -a'" | grep $printer
}

ccp() {
	if [[ -n $1 ]]; then
		if [[ -n $2 ]]; then
			scp $1 user_name@host:$2
		else
			echo "Defaulting to ~/Documents folder."
			scp $1 user_name@host:Documents
		fi
	else
		echo "usage: cscp local_file [remote_directory]"
	fi
}

csp() {
	local printer=115A
	if [[ -n $1 ]]; then
		if [[ -n $2 ]]; then
			printer=$2
		else
			echo Printing to 115A.
		fi
		ssh -t user_name@host "ssh -t $(gshuf -n 1 -e xilonen tlaloc teteoinnan) \"lpr -P $printer $1\""
	else
		echo "usage: csp remote_filepath [printer]"
	fi
}

setopt AUTO_CD
setopt HIST_IGNORE_SPACE

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=7

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx sublime terminalapp brew)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Applications/adt-bundle-mac-x86_64-20131030/sdk/tools:/Applications/adt-bundle-mac-x86_64-20131030/sdk/platform-tools
