# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnostermod"

# Equivalent to `whoami`
DEFAULT_USER=`id -un`

# Aliases
alias zshconfig="st ~/.zshrc"
alias ohmyzsh="stt ~/.oh-my-zsh"
alias zsource="source ~/.zshrc"
alias clr="rm ~/.zsh_history;tab;exit"
alias py="python3"
alias adbt="adb connect 192.168.43.1"
alias brewup="echo 'Updating brew formulae...';brew update;echo 'Upgrading brew packages...';brew upgrade"
alias csl="ssh -t 2015etsung@remote.tjhsst.edu ssh\ $(gshuf -n 1 -e xilonen tlaloc teteoinnan grover honeydew gonzo oscar misspiggie)"
alias printers="lpstat -a"
hash -d cs=~/Documents/School/Computer\ Sys
hash -d repo=~/Documents/Git
hash -d school=~/Documents/School
hash -d trash=~/.Trash

# Command functions
cps() {
	local printer=accepting
	if [[ -n $1 ]]; then
		if [[ $1 -eq '-help' ]]; then
			echo "usage: cspr [printer]"
			return
		fi
		printer=$1
	fi
	ssh -t 2015etsung@remote.tjhsst.edu "ssh -t $(gshuf -n 1 -e xilonen tlaloc teteoinnan grover honeydew gonzo oscar misspiggie) 'lpstat -a'" | grep $printer
}

cscp() {
	if [[ -n $1 ]]; then
		if [[ -n $2 ]]; then
			echo "Sending to folder $2"
			scp $1 2015etsung@remote.tjhsst.edu:$2
		else
			echo "Defaulting to ~/Documents folder."
			scp $1 2015etsung@remote.tjhsst.edu:Documents
		fi
	else
		echo "usage: cscp local_file [remote_directory]"
	fi
}

cpr() {
	local printer=115A
	if [[ -n $1 ]]; then
		if [[ -n $2 ]]; then
			printer=$2
		else
			echo Printing to 115A.
		fi
		ssh -t 2015etsung@remote.tjhsst.edu "ssh -t $(gshuf -n 1 -e xilonen tlaloc teteoinnan grover honeydew gonzo oscar misspiggie) \"lpr -P $printer $1\""
	else
		echo "usage: cpr remote_file [printer]"
	fi
}

csprint() {
	local printer=115A
	local remote_directory=Documents
	local file_name=Error
	if [[ -n $1 ]]; then
		if [[ -n $2 ]]; then
			if [[ -n $3 ]]; then
				remote_directory=$2
				printer=$3
				echo "Sending to folder $2"
				echo "Printing to $3"
			else
				printer=$2
				echo "Defaulting to ~/Documents"
				echo "Printing to $2"
			fi
		else
			echo "Defaulting to ~/Documents"
			echo "Printing to 115A"
		fi
		file_name=$1

		echo "===Sending File==="
		scp $file_name 2015etsung@remote.tjhsst.edu:$remote_directory
		echo "=====Printing====="
		file_name=${file_name//\ /\\ } # insert "\" before spaces again
		ssh -t 2015etsung@remote.tjhsst.edu "ssh -t $(gshuf -n 1 -e xilonen tlaloc teteoinnan grover honeydew gonzo oscar misspiggie) \"lpr -P $printer $remote_directory/$file_name\""
	else
		echo "usage: csprint local_file [printer|remote_directory printer]"
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

# Use vim as editor
export EDITOR="vim"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx sublime terminalapp brew)

source $ZSH/oh-my-zsh.sh

# Uncomment following line if you want to enable powerline
# export POWERLINE_COMMAND=~/Library/Python/2.7/bin/powerline
# source $HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/zsh/powerline.zsh

# Customize to your needs...
export PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:~/Library/Android/sdk/tools:~/Library/Android/sdk/platform-tools:~/.bin
