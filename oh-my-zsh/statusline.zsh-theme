# Original theme from agnoster (https://gist.github.com/smileart/3750104)
# This theme is located at https://github.com/el1t/statusline
# Designed for oh-my-zsh

ZSH_THEME_GIT_PROMPT_DIRTY=' ±'
STATUSBAR_LENGTH=12	# Initialize with default number of spaces/symbols in prompt

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
MIDDLE_BG='white'
SEGMENT_SEPARATOR='⮀'
SEGMENT_SEPARATOR_RIGHT='⮂'

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
	local bg fg
	[[ -n $1 ]] && bg="%K{$1}" || bg="%k"
	[[ -n $2 ]] && fg="%F{$2}" || fg="%f"
	if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
		echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
	else
		echo -n "%{$bg%}%{$fg%} "
	fi
	CURRENT_BG=$1
	[[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
	[[ -n $MIDDLE_BG ]] && MIDDLE_BG="%K{$MIDDLE_BG%}" || MIDDLE_BG="%k"
	if [[ -n $CURRENT_BG ]]; then
		echo -n " %{%F{$CURRENT_BG}$MIDDLE_BG%}$SEGMENT_SEPARATOR"
	else
		echo -n "%{$MIDDLE_BG%}"
	fi
	echo -n "%{%f%}"
}

# Set the bg color for rprompt
prompt_start() {
	[[ -n $MIDDLE_BG ]] && MIDDLE_BG="%K{$MIDDLE_BG%}" || MIDDLE_BG="%k"
	echo -n "%{$MIDDLE_BG%}"
}

# Begin a segment in rprompt
prompt_segment_right() {
	local bg fg bbg
	if [[ -n $1 ]]; then
		bg="%K{$1}"
		bbg="%F{$1}"
	else
		bg="%k"
		bbg="%f"
	fi
	[[ -n $2 ]] && fg="%F{$2}" || fg="%f"
	echo -n " %{$bbg%}$SEGMENT_SEPARATOR_RIGHT%{$fg$bg%} "
	[[ -n $3 ]] && echo -n "$3"
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Status: error/root/background jobs
prompt_status() {
	local symbols
	symbols=
	[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
	[[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

	if [[ -n "$symbols" ]];then
		prompt_segment black default "$symbols"
		(( STATUSBAR_LENGTH += $#symbols + 3 ))
	fi
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
	local virtualenv_path="$VIRTUAL_ENV"
	if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
		local output = "$(basename $virtualenv_path)"
		prompt_segment blue black $output
		(( STATUSBAR_LENGTH += $#output ))
	fi
}

# Context: user@hostname
prompt_context() {
	if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
		local machine="$(print -nP %m)"
		prompt_segment black yellow "$USER@$machine"
		(( STATUSBAR_LENGTH += $#USER + $#machine + 1 ))
	fi
}

# Git: branch, dirty status, commits behind/ahead of remote
prompt_git() {
	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		local ref dirty mode repo_path branch icons
		repo_path=$(git rev-parse --git-dir 2>/dev/null)

		ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
		dirty=$(parse_git_dirty)

		if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
			prompt_segment red white
		elif [[ -n $dirty ]]; then
			prompt_segment yellow black
			(( STATUSBAR_LENGTH += 2 ))
		else
			prompt_segment green black
		fi

		if [[ -e "${repo_path}/BISECT_LOG" ]]; then
			mode=" <B>"
			(( STATUSBAR_LENGTH += 4 ))
		elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
			mode=" >M<"
			((STATUSBAR_LENGTH += 4 ))
		elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
			mode=" >R>"
			(( STATUSBAR_LENGTH += 4 ))
		fi

		branch="${ref/refs\/heads\// }"
		icons="$dirty$(helper_git_remote_status)$mode"
		echo -n $branch$icons
		# Add length of git status, including a space and an arrow, to STATUSBAR_LENGTH
		(( STATUSBAR_LENGTH += $#branch + $#icons + 2 ))
	fi
}

# Helper function: determine commits behind/ahead of remote
helper_git_remote_status() {
	if [[ -n ${$(command git rev-parse --verify ${hook_com[git_branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/} ]]; then
		ahead=$(command git rev-list ${hook_com[git_branch]}@{upstream}..HEAD 2>/dev/null | wc -l | xargs echo)
		behind=$(command git rev-list HEAD..${hook_com[git_branch]}@{upstream} 2>/dev/null | wc -l | xargs echo)

		if [ $behind -gt 0 ]; then
			(( STATUSBAR_LENGTH += $#behind + 2 ))
			echo -n " ↓$behind"
		fi
		if [ $ahead -gt 0 ]; then
			(( STATUSBAR_LENGTH += $#ahead + 2 ))
			echo -n " ↑$ahead"
		fi
	fi
}

# Hg: ?
prompt_hg() {
	local rev status output
	if $(hg id >/dev/null 2>&1); then
		if $(hg prompt >/dev/null 2>&1); then
			if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
				# if files are not added
				prompt_segment red white
				st='±'
			elif [[ -n $(hg prompt "{status|modified}") ]]; then
				# if any modification
				prompt_segment yellow black
				st='±'
			else
				# if working copy is clean
				prompt_segment green black
			fi
			output="$(hg prompt "☿ {rev}@{branch}") $st"
		else
			st=""
			rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
			branch=$(hg id -b 2>/dev/null)
			if $(hg st | grep -q "^\?"); then
				prompt_segment red black
				st='±'
			elif $(hg st | grep -q "^(M|A)"); then
				prompt_segment yellow black
				st='±'
			else
				prompt_segment green black
			fi
			output="☿ $rev@$branch $st"
		fi
		echo -n $output
		(( STATUSBAR_LENGTH += $#output ))
	fi
}

# Dir: current working directory, shortens if longer than available space
prompt_dir {
	local termwidth=$(helper_count_spacing)
	if [[ ${#${(%):-%~}} -gt ${termwidth} ]]; then
		prompt_segment blue white "%${termwidth}<…<%~%<<"
	else
		prompt_segment blue white ${(%):-%~}
	fi
	# ${param:-value} means use param if non-zero length, else value
	# In this context, it should use (%) before %~
	# ${(C)__string__} capitalizes the first character of each word, zsh style
}

# Helper function: count the spaces available for printing the working directory
helper_count_spacing {
	# Store substituted string of trimmed time and history count
	local temp="$(echo $(print -nP %t%!))"
	# From the total width, subtract spaces, left-side length without working directory, (trimmed) time + space, and history count
	echo $(( ${COLUMNS} - $STATUSBAR_LENGTH - $#temp - 1 ))
}

statusbar_left() {
	RETVAL=$?
	prompt_status
	prompt_virtualenv
	prompt_context
	prompt_git
	prompt_hg
	prompt_dir
	prompt_end
}

statusbar_right() {
	prompt_start
	# print time, trimming leading spaces
	prompt_segment_right magenta white "$(echo $(print -nP %t))"
	# print history number
	prompt_segment_right white black "!%{%F{blue}%}%!"
}

# ${var} and $(method) are different!!
# %b = , %f = default foreground, %k = default background, %K = bg color, %F = fg text color, %B = , %E = (apply formatting until) end of line

PROMPT='%{%f%k%b%}
$(statusbar_left)%E
%{%F{blue}%K{white}%}❯%{%k%F{white}%}$SEGMENT_SEPARATOR%{%f%b%}'
RPROMPT='%{$(echotc UP 1)%}$(statusbar_right)%{$(echotc DO 1)%}'
