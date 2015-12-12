#
# A two-line, responsive theme styled after powerline.
# Originally ported from agnoster, in oh-my-zsh (https://github.com/robbyrussell/oh-my-zsh)
#
# Authors:
#   Ellis Tsung (github.com/el1t)
#

#
# ==============Colors==============
# Base |  Color  | Bold | Solarized
# ----------------------------------
#   0  | Black   |   8  |  Base03
#   1  | Red     |   9  |  Orange
#   2  | Green   |  10  |  Base01
#   3  | Yellow  |  11  |  Base00
#   4  | Blue    |  12  |  Base0
#   5  | Magenta |  13  |  Violet
#   6  | Cyan    |  14  |  Base1
#   7  | White   |  15  |  Base3
#

# Global vars/constants
_prompt_statusline_length=0
_prompt_statusline_git=''
_prompt_statusline_bg=(7 15 7 '') # foreground, background, middle, current
_prompt_statusline_symbols=(   )
_prompt_statusline_left_segments=(status user git-branch directory)
_prompt_statusline_right_segments=(git-status clock history machine)

#
# Segment drawing utility
#

prompt_statusline_draw() {
	local -a left right start end center diamond standalone no_draw warning
	local escape_sequences='%([BSUbfksu]|([FB]|){*})'
	zparseopts -D l=left -left=left \
		r=right -right=right \
		s=start -start=start \
		e=end -end=end \
		c=center -center=center \
		d=diamond -diamond=diamond \
		a=standalone -standalond=standalone \
		n=no_draw -no-draw=no_draw \
		w=warning -warning=warning

	# Begin a left segment
	if [[ -n "$left" ]]; then
		local bg fg
		[[ -n "$1" ]] && bg="%K{$1}" || bg='%k'
		[[ -n "$2" ]] && fg="%F{$2}" || fg='%f'
		if [[ -n "$_prompt_statusline_bg[4]" ]]; then
			if [[ "$1" != "$_prompt_statusline_bg[4]" ]]; then
				echo -n " $bg%F{$_prompt_statusline_bg[4]}$_prompt_statusline_symbols[4] "
			else
				echo -n " $bg%F{$_prompt_statusline_bg[2]}$_prompt_statusline_symbols[3] "
			fi
			(( _prompt_statusline_length += 2 ))
		else
			echo -n "$bg "
		fi
		_prompt_statusline_bg[4]="$1"
		echo -n "$fg"
		if [[ -n "$3" ]]; then
			echo -n "$3"
			(( _prompt_statusline_length += ${#${(S%%)${3}//$~escape_sequences/}} + 2 ))
		fi

	# Begin a right segment
	elif [[ -n "$right" ]]; then
		local bg fg
		[[ -n "$1" ]] && bg="%K{$1}" || bg='%k'
		[[ -n "$2" ]] && fg="%F{$2}" || fg='%f'
		if [[ -n "$_prompt_statusline_bg[4]" ]]; then
			if [[ "$1" != "$_prompt_statusline_bg[4]" ]]; then
				echo -n "%F{$_prompt_statusline_bg[4]}$bg%S$_prompt_statusline_symbols[1]%s$fg "
			else
				echo -n "$bg%F{$_prompt_statusline_bg[2]}$_prompt_statusline_symbols[2]$fg "
			fi
		else
			echo -n "%F{$1}$_prompt_statusline_symbols[1]$bg$fg "
		fi
		_prompt_statusline_bg[4]="$1"
		if [[ -n "$3" ]]; then
			echo -n "$3 "
		fi

	# Used to count the length of right prompt segments without drawing segments
	elif [[ -n "$no_draw" ]]; then
		if [[ -n "$_prompt_statusline_bg[4]" ]]; then
			(( _prompt_statusline_length += 3 ))
		else
			(( _prompt_statusline_length += 2 ))
			_prompt_statusline_bg[4]=0
		fi
		if [[ -n "$3" ]]; then
			(( _prompt_statusline_length += ${#${(S%%)${3}//$~escape_sequences/}} + 1 ))
		fi

	# Start the right prompt, setting the current bg color
	elif [[ -n "$start" ]]; then
		local bg
		[[ -n "$_prompt_statusline_bg[3]" ]] && bg="%K{$_prompt_statusline_bg[3]}" || bg='%k'
		echo -n "$bg"
		_prompt_statusline_bg[4]="$_prompt_statusline_bg[3]"

	# End the left prompt, closing any open segments
	elif [[ -n "$end" ]]; then
		local bg
		[[ -n "$_prompt_statusline_bg[3]" ]] && bg="%K{$_prompt_statusline_bg[3]}" || bg='%k'
		if [[ -n "$_prompt_statusline_bg[4]" ]]; then
			echo -n " %F{$_prompt_statusline_bg[4]}$bg$_prompt_statusline_symbols[4]"
			[[ -z "$uncalculated" ]] && (( _prompt_statusline_length += 2 ))
		else
			echo -n "$_prompt_statusline_bg[3]"
		fi
		echo -n '%f'

	# Center a prompt
	elif [[ -n "$center" ]]; then
		local length=$(( (COLUMNS - $#3 - 4) / 2 ))
		[[ -n "$4" ]] && echo -n "%K{$4}"
		# Pad spaces
		echo -n "${(l:$length:: :)}"

	# Output a warning
	elif [[ -n "$warning" ]]; then
		print -P "$(prompt_statusline_draw -a 4 7 Statusline)%F{1}%UWarning%u%f: $1" >&2
	fi

	#  Sample output 
	if [[ -n "$diamond" ]]; then
		local padding_color="$4"
		[[ -z "$4" ]] && padding_color="$_prompt_statusline_bg[2]"
		echo -n "%F{$1}%K{$padding_color}$_prompt_statusline_symbols[1]%F{$2}%K{$1} $3 %F{$1}%K{$padding_color}$_prompt_statusline_symbols[4]%f%E%k"

	# Standalone
	elif [[ -n "$standalone" ]]; then
		local bg fg
		[[ -n "$1" ]] && bg="%K{$1}" || bg="%K{$_prompt_statusline_bg[1]}"
		[[ -n "$2" ]] && fg="%F{$2}" || fg='%f'
		echo -n "$fg$bg $3 %F{$_prompt_statusline_bg[2]}%S$_prompt_statusline_symbols[4]%s%f%k "
	fi
}

#
# Segment components
#

prompt_statusline_segments() {
	local -a left right no_draw
	zparseopts -D r=right -right=right \
		l=left -left=left \
		n=no_draw -no-calc=no_draw

	# Start right prompt
	local draw_options
	if [[ -n "$right" ]]; then
		draw_options='-r'
	elif [[ -n "$no_draw" ]]; then
		draw_options='-n'
	elif [[ -n "$left" ]]; then
		draw_options='-l'
	fi

	while (( # > 0 )); do
		case "$1" in
			# Status: root/error/background jobs
			(status)
				local symbols=''
				[[ "$UID" == 0 || "$EUID" == 0 ]] && symbols+='%F{3}⚡'
				(( retval != 0 )) && symbols+='%F{1}✘'
				[[ -n $(jobs -l) ]] && symbols+='%F{6}⚙'

				if [[ -n "$symbols" ]]; then
					prompt_statusline_draw "$draw_options" 0 '' "$symbols"
				fi
				;;

			# User: username
			(user)
				if [[ -n "$SSH_CLIENT$SSH_TTY" ]]; then
					prompt_statusline_draw "$draw_options" 0 3 "$LOGNAME"
				fi
				;;

			# Machine: machine name
			(machine)
				if [[ -n "$SSH_CLIENT$SSH_TTY" ]]; then
					prompt_statusline_draw "$draw_options" 3 0 '@%m'
				fi
				;;

			# Git: branch, dirty status, commits behind/ahead of remote
			(git-branch)
				if [[ -n "$_prompt_statusline_git" ]]; then
					# If async has finished
					if (( _prompt_statusline_precmd_async_pid == 0 )); then
						# Declaring this inside the if statement would not be local
						local git_output="${(e)git_info[prompt]}"
						if [[ -n "$git_output" ]]; then
							prompt_statusline_draw "$draw_options" "$git_info[bg]" 7 "$git_output"
						fi
					else
						# Display placeholder for async, gray color
						prompt_statusline_draw "$draw_options" 14 0 ' ...   '
					fi
				fi
				;;

			# Git: format action, output other statuses defined in git_info[rprompt]
			(git-status)
				# If async has finished
				if [[ -n "$_prompt_statusline_git" && "$_prompt_statusline_precmd_async_pid" -eq 0 ]]; then
					if [[ -n "$git_info[rprompt]" ]]; then
						case $git_info[action] in
							(apply)
								prompt_statusline_draw "$draw_options" "$_prompt_statusline_bg[1]" '' '<A<'
								;;
							(bisect)
								prompt_statusline_draw "$draw_options" "$_prompt_statusline_bg[1]" '' '<B>'
								;;
							(cherry-pick|cherry-pick-sequence)
								prompt_statusline_draw "$draw_options" "$_prompt_statusline_bg[1]" '' '<C<'
								;;
							(merge)
								prompt_statusline_draw "$draw_options" "$_prompt_statusline_bg[1]" '' '>M<'
								;;
							(rebase|rebase-interactive|rebase-merge)
								prompt_statusline_draw "$draw_options" "$_prompt_statusline_bg[1]" '' '>R>'
								;;
						esac
						prompt_statusline_draw "$draw_options" "$_prompt_statusline_bg[1]" '' "$git_info[rprompt]"
					fi
				fi
				;;

			# Dir: current working directory, shortens if longer than available space
			(directory)
				local directory="${${(%):-%~}}"
				local hashed_directory="${${directory[2,-1]%%/*}:-$directory[1]}"
				prompt_statusline_draw "$draw_options" 4 7 "$hashed_directory"
				# Replace directory with empty string if at base of hashed directory, else eliminate hashed portion
				directory="${${directory:#^?*/*}:+${directory#?*/}}"
				if [[ -n "$directory" ]]; then
					# Count spaces available for printing the working directory
					# Subtract the extra 3 chars used for the current segment and an extra space in case
					local spacing=$(( COLUMNS - _prompt_statusline_length - 3 - 1 ))
					local length="$#directory"
					if (( length <= spacing )); then
						prompt_statusline_draw "$draw_options" 4 7 "$directory"
					else
						# Shorten path as much as necessary
						local dir_segment
						prompt_statusline_draw "$draw_options" 4 7
						for dir_segment in "${(@s:/:)directory:h}"; do
							if (( length > spacing )); then
								echo -n "$dir_segment[1]/"
								(( length -= $#dir_segment - 1 ))
							else
								echo -n "$dir_segment/"
							fi
						done
						echo -n "${directory:t}"
					fi
				fi
				;;

			(clock)
				prompt_statusline_draw "$draw_options" 5 7 "${${(%%):-%t}## }"
				;;

			(history)
				prompt_statusline_draw "$draw_options" "$_prompt_statusline_bg[1]" '' '!%F{4}%!'
				;;

			(*)
				prompt_statusline_draw -w "$1 is not a valid segment!"
				;;
		esac
		shift
	done
}

# Output runtime of previous task
prompt_statusline_elapsed_time() {
	if [[ -n "$_prompt_statusline_start_time" ]]; then
		local end_time=$(( SECONDS - _prompt_statusline_start_time ))
		if (( end_time >= 10 )); then
			local -a output
			if (( end_time >= 60 )); then
				if (( end_time >= 3600 )); then
					output+=("$(( end_time / 3600 ))h")
					end_time=$(( end_time % 3600 ))
				fi
				output+=("$(( end_time / 60 ))m")
				end_time=$(( end_time % 60 ))
			fi
			output+=("${end_time}s")
			echo
			print -P '$(prompt_statusline_draw -cd 13 7 "$output" $_prompt_statusline_bg[1])'
		fi
		unset _prompt_statusline_start_time
	fi
}

# Draw prompt(s)
prompt_statusline() {
	local retval="$?"
	local -a left right single
	zparseopts l=left -left=left \
		r=right -right=right \
		s=single -single=single

	if [[ -n "$left" ]]; then
		[[ -z "$single" && -n "$TMUX" ]] && echo -n "%K{$_prompt_statusline_bg[1]}%{${(l:$COLUMNS:: :)}%}%k%{$(echotc LEFT $COLUMNS)%}"
		prompt_statusline_segments -n $_prompt_statusline_right_segments
		_prompt_statusline_bg[4]=''
		prompt_statusline_segments -l $_prompt_statusline_left_segments
		prompt_statusline_draw -e
		if [[ -n "$single" ]]; then
			echo -n '%k'
		elif [[ -z "$TMUX" ]]; then
			echo -n '%E'
		fi

	elif [[ -n "$right" ]]; then
		prompt_statusline_draw -s
		prompt_statusline_segments -r $_prompt_statusline_right_segments
	fi
}

#
# Theme setup functions
#

prompt_statusline_precmd_async() {
	# Get Git repository information manually
	# From prezto/modules/git/functions/git-info
	unset git_info
	typeset -gA git_info
	local prompt rprompt
	local ahead_and_behind added deleted modified renamed unmerged untracked

	# Try displaying branch > position > commit
	# Branch
	prompt="${$(git symbolic-ref HEAD 2> /dev/null)#refs/heads/}"
	if [[ -n "$prompt" ]]; then
		prompt=" $prompt"

		# Get ahead and behind counts.
		ahead_and_behind="$(${(z)$(git rev-list --count --left-right HEAD...@{upstream})} 2> /dev/null)"

	    # Format ahead.
	    if [[ -n "$ahead_and_behind[(w)1]" ]]; then
			rprompt="%F{3}↑$ahead_and_behind[(w)1]%f"
		fi

		# Format behind.
		if [[ -n "$ahead_and_behind[(w)2]" ]]; then
			rprompt+='%F{3}↓$ahead_and_behind[(w)2]%f'
		fi
	else
		# Position
		prompt="$(git describe --contains --all HEAD 2> /dev/null)"
		if [[ -n "$prompt" ]]; then
			prompt=":$prompt"
		else
			prompt="$(git rev-parse HEAD 2> /dev/null)"
		fi
	fi

	# Get stashed
	if [[ -n $(git stash list 2> /dev/null) ]]; then
		rprompt+='%F{6}§%f'
	fi

	# Get current status
	while IFS=$'\n' read line; do
		# Count added, deleted, modified, renamed, unmerged, untracked.
		[[ "$line" == ([ACDMT][\ MT]|[ACMT]D)\ * ]] && added='%F{2}✚%f'
		[[ "$line" == [\ ACMRT]D\ * ]] && deleted='%F{1}✖%f'
		[[ "$line" == ?[MT]\ * ]] && modified='3'
		[[ "$line" == R?\ * ]] && renamed='%F{9}➜%f'
		[[ "$line" == (AA|DD|U?|?U)\ * ]] && unmerged='%F{3}₥%f'
		[[ "$line" == \?\?\ * ]] && untracked='1'
	done < <(${(z)$(git status --porcelain --ignore-submodules=untracked)} 2> /dev/null)

	rprompt+="$added$deleted$renamed$unmerged"

	# Set git_info fields
	git_info[prompt]="$prompt"
	git_info[rprompt]="$rprompt"
	# Manual coalesce
	if [[ -n "$untracked" ]]; then
		git_info[bg]="$untracked"
	elif [[ -n "$modified" ]]; then
		git_info[bg]="$modified"
	else
		git_info[bg]=2
	fi

	# Store array in temp file
	typeset -p git_info >! "$_prompt_statusline_precmd_async_data"

	# Signal completion to parent process.
	kill -WINCH $$
}

prompt_statusline_git_info() {
	# Append Git status.
	if [[ "$_prompt_statusline_precmd_async_pid" -gt 0 && -s "$_prompt_statusline_precmd_async_data" ]]; then
		alias typeset='typeset -g'
		source "$_prompt_statusline_precmd_async_data"
		unalias typeset
		# Reset PID.
		_prompt_statusline_precmd_async_pid=0

		# Display prompt.
		zle && zle reset-prompt
	fi
}

prompt_statusline_precmd() {
	setopt LOCAL_OPTIONS
	unsetopt XTRACE KSH_ARRAYS

	# Check previous task runtime
	prompt_statusline_elapsed_time

	# Kill the old process of slow commands if it is still running.
	if (( _prompt_statusline_precmd_async_pid > 0 )); then
		kill -KILL "$_prompt_statusline_precmd_async_pid" &> /dev/null
	fi

	# Split off async task to check git status if in git repo
	if $(git rev-parse --is-inside-work-tree 2> /dev/null); then
		_prompt_statusline_git=1
		# Compute slow commands in the background.
		trap prompt_statusline_git_info WINCH
		prompt_statusline_precmd_async &!
		_prompt_statusline_precmd_async_pid="$!"
	else
		unset _prompt_statusline_git
	fi
}

prompt_statusline_preexec() {
	_prompt_statusline_start_time="$SECONDS"
}

prompt_statusline_help() {
	print -P \
"This prompt supports solarized light and dark. Solarized light with a white statusbar on two lines is the default style.
You can invoke it thus:

	prompt statusline [--color <color>] [--dark] [--single]

Set this theme with the following in your rc file:

	zstyle ':prezto:module:prompt' theme 'statusline' [-c|--color <color>] [-d|--dark] [-f|--font] [-s|--single]

%BOPTIONS%b
	-c, --color <color>
		Set the statusbar background color. Does not work in single-line mode.

	-d, --dark
		Apply the dark theme.

	-f, --font <font>
		Customize the special characters used for dividers. <font> may be powerline, legacy, blocks, or none.

	-s, --single
		Fit the prompt to one line."
}

# %s = undo standout, %u = remove underline, %b = unbold, %f = default foreground, %k = default background
# %S = standout, %U = underline, %B = bold, %F = fg (text) color, %K = bg color, %E = clear to end of line
prompt_statusline_setup() {
	setopt LOCAL_OPTIONS
	unsetopt XTRACE KSH_ARRAYS
	prompt_opts=(cr percent subst)
	_prompt_statusline_precmd_async_pid=0
	_prompt_statusline_precmd_async_data="${TMPPREFIX}-prompt_statusline_data"

	# Load required functions
	autoload -Uz add-zsh-hook

	# Add hooks
	add-zsh-hook preexec prompt_statusline_preexec
	add-zsh-hook precmd prompt_statusline_precmd

	# Customize theme
	local -a dark color single font
	zparseopts d=dark -dark=dark \
		c:=color -color:=color \
		s=single -single=single \
		f:=font -font:=font


	if [[ -n "$dark" ]]; then
		_prompt_statusline_bg=(0 8 0)
	else
		_prompt_statusline_bg=(7 15 7)
	fi

	# Set single-line prompt
	if [[ -n "$single" ]]; then
		if [[ -n "$color" ]]; then
			prompt_statusline_draw -w 'cannot set color (-c) when in single-line mode (-s)'
		fi
		_prompt_statusline_bg[3]="$_prompt_statusline_bg[2]"
		PROMPT="%{$(print $FX[none])%}"'
$(prompt_statusline -sl)'"%{$(print $FX[none])%}"
		RPROMPT="%{$terminfo[cuf1]%}"'$(prompt_statusline -sr)'"%{$terminfo[cuf1]%}"

	else
		if [[ -n "$color" ]]; then
			_prompt_statusline_bg[3]="$color[2]"
		fi
		PROMPT="%{$(print $FX[none])%}"'
$(prompt_statusline -l)
'"%F{4}%K{$_prompt_statusline_bg[1]}❯%K{$_prompt_statusline_bg[2]}%F{$_prompt_statusline_bg[1]}$_prompt_statusline_symbols[4]%f%k"
		RPROMPT='%{$terminfo[cuu1]$terminfo[cuf1]%}$(prompt_statusline -r)%{$(echotc DO 1)%}'
	fi
	if [[ -n "$font" ]]; then
		case "$font[2]" in
			(powerline)
				_prompt_statusline_symbols=(⮂   ⮀)
				;;
			(legacy)
				_prompt_statusline_symbols=(◀ '<' '>' ▶︎)
				;;
			(blocks)
				_prompt_statusline_symbols=(◼ '|' '|' ◼︎)
				;;
			(none)
				_prompt_statusline_symbols=('' '' '' ''︎)
				;;
			(*)
				prompt_statusline_draw -w "font type not found: $font[2]"
				;;
		esac
	fi

	# Secondary prompt, printed when the shell needs more information to complete a command
	PS2="%F{6}%K{$_prompt_statusline_bg[1]}❯%k%F{$_prompt_statusline_bg[1]}$_prompt_statusline_symbols[4]%f"
	RPS2="%k%F{$_prompt_statusline_bg[1]}$_prompt_statusline_symbols[1]%F{6}%K{$_prompt_statusline_bg[1]} %_%E"

	# Selection prompt used within a select loop
	PS3="$(prompt_statusline_draw -a 7 13 'Select:')"

	# Execution trace prompt
	# setopt xtrace # disable with unsetopt xtrace
	PS4="$(prompt_statusline_draw -a '' 2 '%N%f:%F{4}%i')"

	# Spelling prompt used to correct spelling errors
	SPROMPT="$(prompt_statusline_draw -a 9 7 'Correction:')change %B%F{1}%R%b%f to %B%F{2}%r%b%f [%Unyae%u]? "
}

prompt_statusline_setup "$@"