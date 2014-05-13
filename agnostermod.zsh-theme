# Original theme agnoster
# Forked from https://gist.github.com/smileart/3750104

ZSH_THEME_GIT_PROMPT_DIRTY='±'
CHECK_CHANGES=

function _git_info() {
	local ref dirty mode repo_path

	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		repo_path=$(git rev-parse --git-dir 2>/dev/null)
		local BG_COLOR=green
		ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
		if [[ -n $(parse_git_dirty) ]]; then
			BG_COLOR=yellow
			FG_COLOR=black
		fi

		if [[ ! -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
			BG_COLOR=red
			FG_COLOR=white
		fi

		if [[ -e "${repo_path}/BISECT_LOG" ]]; then
			mode=" <B>"
		elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
			mode=" >M<"
		elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
			mode=" >R>"
		fi

		setopt promptsubst
		autoload -Uz vcs_info

		zstyle ':vcs_info:*' enable git
		if [[ $(fc -ln $(($HISTCMD-1))) =~ "git.*" || -n CHECK_CHANGES ]]; then
			CHECK_CHANGES=
			zstyle ':vcs_info:*' get-revision true
			zstyle ':vcs_info:*' check-for-changes true
			zstyle ':vcs_info:*' stagedstr '✚'
			zstyle ':vcs_info:git:*' unstagedstr '●'
			zstyle ':vcs_info:*' formats ' %b ⭠ %u %c'
			zstyle ':vcs_info:*' actionformats ' %b ⭠ %u %c'
		else
			zstyle ':vcs_info:*' formats ' %b ⭠'
			zstyle ':vcs_info:*' actionformats ' %b ⭠'
		fi
		vcs_info

		echo -n "%{%K{$BG_COLOR}%}⮀%{%F{$FG_COLOR}%}${vcs_info_msg_0_%% }${mode} %{%F{$BG_COLOR}%K{blue}%}⮀"
	else
		echo -n "%{%K{blue}%}⮀"
	fi
}

# check-for-changes when changing directory
prompt_chpwd() {
    CHECK_CHANGES=1
}
add-zsh-hook chpwd prompt_chpwd

function prompt_hg() {
	if $(hg id >/dev/null 2>&1); then
		local rev status BG_COLOR
		if $(hg prompt >/dev/null 2>&1); then
			if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
				# if files are not added
				BG_COLOR=red
				FG_COLOR=white
				st='±'
			elif [[ -n $(hg prompt "{status|modified}") ]]; then
				# if any modification
				BG_COLOR=yellow
				FG_COLOR=black
				st='±'
			else
				# if working copy is clean
				BG_COLOR=green
				FG_COLOR=black
			fi
			echo -n "%{%K{$BG_COLOR}%}⮀%{%F{$FG_COLOR}%}"
			echo -n $(hg prompt "☿ {rev}@{branch}") $st
			echo -n "% {%F{$BG_COLOR}%K{blue}%}⮀"
		else
			st=""
			rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
			branch=$(hg id -b 2>/dev/null)
			if `hg st | grep -Eq "^\?"`; then
				# prompt_segment red black
				st='±'
			elif `hg st | grep -Eq "^(M|A)"`; then
				# prompt_segment yellow black
				st='±'
			else
				# rompt_segment green black
			fi
			echo -n "☿ $rev@$branch" $st
		fi
	fi
}

# prints working directory, but shortens if longer than space
function get_PWD {
	local termwidth
	(( termwidth = $(put_spacing) ))
	if [[ ${#${(%):-%~}} -gt ${termwidth}  ]]; then
		echo "%${termwidth}<…<%~%<<"
	else
		echo "${(%):-%~}"
	fi
	# What is %~ and (%)??
}

# more like count spacing, simply counts the spaces available
function put_spacing {
	local SPACING_COUNT=0
	# git status
	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		((SPACING_COUNT=2 + ${#$(_git_info)} + ${#$(parse_git_dirty)}))
	fi
	# superuser
	if [ $UID -eq 0 ]; then
		((SPACING_COUNT = SPACING_COUNT + 4))
	fi
	local termwidth
	(( termwidth = ${COLUMNS} - 27 - ${#$%n} - ${#$%m} - ${#$%t} - ${SPACING_COUNT} - ${#$%!}))
	# from the total width, subtract spaces, ___, ___, time, extra spacing, and history count
	echo $termwidth
	# local spacing=""
	# for i in {1..$termwidth}; do
	# 	spacing="${spacing} "
	# done
	# echo $spacing
}

# prints status of last command and the user name
function status() {
	echo -n "%(?.%{%F{green}%}✔.%{%F{red}%}✘)"
	if [[ $(jobs -l | wc -l) -gt 0 ]]; then
		echo -n " %{%F{cyan}%}⚙"
	fi
	echo -n "%{%F{yellow}%} %n %{%F{black}%}"
}

function statusbar_left() {
	echo -n "%{%K{black}%} "
	status
	_git_info
	prompt_hg
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

#PROMPT_DIR='%{%F{white}%} %~%  '
PROMPT_SU='%(!.%{%k%F{blue}%K{black}%}⮀%{%F{yellow}%} ⚡ %{%F{black}%K{red}%}.%{%F{blue}%K{white}%})⮀'

PROMPT='%{%f%k%b%}
$(statusbar_left) $PROMPT_SU%E
%{%K{white}%}$(virtualenv_info)❯%{%k%F{white}%}⮀%{%f%k%b%}'
RPROMPT='%{$(echotc UP 1)%}$(statusbar_right)%E%{$reset_color%}%{$(echotc DO 1)%}'
