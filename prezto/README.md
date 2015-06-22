Statusline for Prezto
===========
This version is more optimized than the oh-my-zsh version, and features more segments and information.

## Installation
### Automatic
```zsh
zsh "$(curl -fsSL https://raw.githubusercontent.com/el1t/statusline/master/prezto/install)"
```
[install](install) will install statusline, prezto, and other requisites as needed.

### Manual
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
Also in `zpreztorc`, change the theme setting as follows:
```zsh
zstyle ':prezto:module:prompt' theme 'statusline'             # Default light theme
zstyle ':prezto:module:prompt' theme 'statusline' 'dark'      # Solarized dark theme
zstyle ':prezto:module:prompt' theme 'statusline' 'light' ''  # Light with transparent statusbar
```
Last but not least, ensure that this custom [patched font](setup/MenloforPowerline-Regular.otf) is installed and enabled in your terminal.
Happy theming!

##Features
- Asynchronous git status loading
- Task runtime
- Light and dark solarized themes
- Contextual segments
- Modular design
- Custom `PS1`, `RPS1`, `PS2`, `RPS2`, `PS3`, `PS4`, `SPROMPT`, and completion formatting
- Tmux support

##Segments
- Exit status/running jobs: shows indicator for previous task
- Username: when in remote shell
- Git branch/position/commit and status: when inside git repository
- Directory: dynamically truncated when too long
- Time: 12-hour clock
- History number: index of current line in zsh history
- Machine name: when in remote shell
