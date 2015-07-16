Statusline for Prezto
===========
This version is more optimized than the oh-my-zsh version, and features more segments and information.

## Installation
### Automatic
```zsh
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/el1t/statusline/master/prezto/install)"
```
[install](install) will install statusline, prezto, and other requisites as needed.

### Manual
#### Prerequisites
 - zsh `5.0.0+` and git `2.0.0+`
 - Install [this font](setup/MenloforPowerline-Regular.otf) in your terminal
 - Recommended: Install a [solarized light](setup/Solarized\ Light.terminal) or [solarized dark](setup/Solarized\ Dark.terminal) Terminal.app profile

#### Theme files
To move `prompt_statusline_setup` to your prezto installation folder, run
```zsh
curl -o ~/.zprezto/modules/prompt/functions/prompt_statusline_setup https://raw.githubusercontent.com/el1t/statusline/master/prezto/prompt_statusline_setup
```
In `zpreztorc`, ensure the following plugins are enabled:
```zsh
zstyle ':prezto:load' pmodule \
	'environment' \
	'terminal' \
	'editor' \
	'history' \
	'directory' \
	'spectrum' \
	'utility' \
	'completion' \
	'git' \
	'prompt'
```
Run `prompt -s statusline` to enable the theme or run `prompt -h statusline` for more info. Happy theming!

## Customization
You can customize the theme's appearance in `zpreztorc`:
```zsh
zstyle ':prezto:module:prompt' theme 'statusline'             # Default light theme
zstyle ':prezto:module:prompt' theme 'statusline' --dark      # Solarized dark theme
zstyle ':prezto:module:prompt' theme 'statusline' --color ''  # Transparent statusbar
zstyle ':prezto:module:prompt' theme 'statusline' --single    # Single-line prompt
```
Segments are easy to add and remove, just edit the following arrays:
```zsh
_prompt_statusline_left_segments=(status user git-branch directory)
_prompt_statusline_right_segments=(git-status clock history machine)
```

## Features
- *Asynchronous* git status loading
- Task *runtime*
- *Light* and *dark* themes
- *Contextual* segments
- Fully *modular* design
- Custom `PS1`, `RPS1`, `PS2`, `RPS2`, `PS3`, `PS4`, `SPROMPT`, and completion formatting
- *Dual-* and *single-line* prompts
- *Tmux* compatible

## Segments
| Name       | Description               | Context                      |
| ---------- | ------------------------- | ---------------------------- |
| status     | SU/exit code/running jobs | when statuses are present    |
| user       | username                  | when in a remote shell       |
| machine    | machine name              | when in a remote shell       |
| git-branch | branch/position/commit    | when inside a git repository |
| git-status | stashed/behind/ahead/etc. | when inside a git repository |
| directory  | current working directory | dynamically truncated        |
| time       | 12-hour clock             | always                       |
| history    | index in zsh history      | always                       |
