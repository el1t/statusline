# Original theme agnoster, in oh-my-zsh (https://github.com/robbyrussell/oh-my-zsh)
# Forked from https://gist.github.com/smileart/3750104
# This mod is located here: https://github.com/el1t/agnostermod/

ZSH_THEME_GIT_PROMPT_DIRTY='± '
local GIT_OUTPUT=

function _git_info() {
	local ref dirty mode repo_path BRANCH

	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		local BG_COLOR=green
		ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
		dirty=$(parse_git_dirty)

		if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
			BG_COLOR=red
			FG_COLOR=white
		elif [[ -n $dirty ]]; then
			BG_COLOR=yellow
			FG_COLOR=black
			GIT_OUTPUT=1
		fi

		echo -n "%{%K{$BG_COLOR}%}⮀%{%F{$FG_COLOR}%} "

		repo_path=$(git rev-parse --git-dir 2>/dev/null)
		if [[ -e "${repo_path}/BISECT_LOG" ]]; then
			mode=" <B>"
			GIT_OUTPUT+=1
		elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
			mode=" >M<"
			GIT_OUTPUT+=1
		elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
			mode=" >R>"
			GIT_OUTPUT+=1
		fi

		# number of chars in dirty (above), branch, mode (above), and spaces + symbols
		BRANCH=${${ref/refs\/heads\/}%%}
		echo -n "⭠ $BRANCH $dirty$(_git_remote_status)${mode}%{%F{$BG_COLOR}%K{blue}%}⮀"
		(( GIT_OUTPUT += ${#BRANCH} + 3 + 3 ))
	else
		GIT_OUTPUT=1
		echo -n "%{%K{blue}%}⮀"
	fi
}

_git_remote_status() {
	remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
	if [[ -n ${remote} ]]; then
		ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l | xargs echo)
		behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l | xargs echo)

		if [ $behind -gt 0 ] || [ $ahead -gt 0 ]; then
			if [ $behind -gt 0 ]; then
				(( GIT_OUTPUT += $#behind ))
				echo -n "↓$behind"
			fi
			if [ $ahead -gt 0 ]; then
				(( GIT_OUTPUT += $#ahead ))
				echo -n "↑$ahead"
			fi
			echo -n " "
		fi
	fi
}

# prints working directory, but shortens if longer than space
function get_PWD {
	local termwidth=$(count_spacing)
	if [[ ${#${(%):-%~}} -gt ${termwidth} ]]; then
		echo "%${termwidth}<…<%~%<<"
	else
		echo "${(%):-%~}"
	fi
	# What is %~ and (%)??
}

# simply counts the spaces available
function count_spacing {
	# git status built in
	# superuser
	if [ $UID -eq 0 ]; then
		(( GIT_OUTPUT += 4 ))
	fi
	# from the total width, subtract spaces, name, machine name, time, extra spacing, history count, and git output
	echo $(( ${COLUMNS} - 27 - ${#$%n} - ${#$%m} - ${#$%t} - $GIT_OUTPUT - ${#$%!} ))
}

# prints status of last command and the user name
function status() {
	echo -n "%(?.%{%F{green}%}✔.%{%F{red}%}✘)"
	# if there are background jobs
	if [[ $(jobs -l | wc -l) -gt 0 ]]; then
		echo -n " %{%F{cyan}%}⚙"
	fi
	echo -n "%{%F{yellow}%} %n %{%F{black}%}"
}

function statusbar_left() {
	echo -n "%{%K{black}%} "
	status
	_git_info
	# prompt_hg
	echo -n "%{%F{white}%} "
	get_PWD
}

function statusbar_right() {
	# print color depending on superuser
	echo -n "%(!.%{%K{red}%F{magenta}%}.%{%K{white}%F{magenta}%})"
	# print time
	echo -n "⮂%{%K{magenta}%F{white}%} %t "
	# print machine name
	echo -n "%{%F{yellow}%}⮂%{$fg[black]%K{yellow}%} @%m "
	# print history number
	echo -n "%{%F{white}%}⮂%{%K{white}%f%} !%{%B%F{blue}%}%!"
}

function virtualenv_info {
		[ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# ${var} and $(method) are different!!
# %b = , %f = , %k = , %K = highlight, %F = foreground text, %B = , %E = (apply formatting until) to end of line

PROMPT_SU='%(!.%{%k%F{blue}%K{black}%}⮀%{%F{yellow}%} ⚡ %{%F{black}%K{red}%}.%{%F{blue}%K{white}%})⮀'

PROMPT='%{%f%k%b%}
$(statusbar_left) $PROMPT_SU%E
%{%K{white}%}$(virtualenv_info)❯%{%k%F{white}%}⮀%{%f%k%b%}'
RPROMPT='%{$(echotc UP 1)%}$(statusbar_right)%E%{$reset_color%}%{$(echotc DO 1)%}'
