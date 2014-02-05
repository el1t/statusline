# Original theme agnoster
# Forked from https://gist.github.com/smileart/3750104

ZSH_THEME_GIT_PROMPT_DIRTY='±'
function _git_prompt_info() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
	echo "${ref/refs\/heads\//⭠ }$(parse_git_dirty)"
}

function _git_info() {
	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		local BG_COLOR=green
		if [[ -n $(parse_git_dirty) ]]; then
			BG_COLOR=yellow
			FG_COLOR=black
		fi

		if [[ ! -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
				BG_COLOR=red
				FG_COLOR=white
		fi
		echo "%{%K{$BG_COLOR}%}⮀%{%F{$FG_COLOR}%} $(_git_prompt_info) %{%F{$BG_COLOR}%K{blue}%}⮀"
	else
		echo "%{%K{blue}%}⮀"
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
		((SPACING_COUNT=2 + ${#$(_git_prompt_info)} + ${#$(parse_git_dirty)}))
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

function virtualenv_info {
		[ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# ${var} and $(method) are different!!
# %b = ,%f = ,%k = ,%K = ,%F = ,%B = ,%E = (apply formatting until) to end of line

PROMPT_HOST='%{%b%f%K{black}%} %(?.%{%F{green}%}✔.%{%F{red}%}✘)%{%F{yellow}%} %n %{%F{black}%}'
#PROMPT_DIR='%{%F{white}%} %~%  '
PROMPT_SU='%(!.%{%k%F{blue}%K{black}%}⮀%{%F{yellow}%} ⚡ %{%F{black}%K{red}%}.%{%F{blue}%K{white}%})⮀'

PROMPT='%{%f%k%b%}
$PROMPT_HOST$(_git_info)%{%F{white}%} $(get_PWD) $PROMPT_SU%E
%{%K{white}%}$(virtualenv_info)❯%{%k%F{white}%}⮀%{%f%k%b%}'
RPROMPT='%{$(echotc UP 1)%}%(!.%{%K{red}%F{magenta}%}.%{%K{white}%F{magenta}%})⮂%{%K{magenta}%F{white}%} %t %{%F{yellow}%}⮂%{$fg[black]%K{yellow}%} @%m %{%F{white}%}⮂%{%K{white}%f%} !%{%B%F{blue}%}%!%E%{$reset_color%}%{$(echotc DO 1)%}'
