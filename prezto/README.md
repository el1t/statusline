Statusline for Prezto
===========
## Installation
### Automatic
```zsh
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/el1t/statusline/master/prezto/install)"
```
[install](install) will install statusline, prezto, and other dependencies as needed.

### Manual
#### Prerequisites (for best results)
- [Custom Powerline menlo font](setup/MenloforPowerline-Regular.otf), or a powerline-patched font (see `--font`)
- [Solarized light](setup/Solarized\ Light.terminal) or [solarized dark](setup/Solarized\ Dark.terminal) Terminal.app profiles
- zsh `5.0.0+` and git `2.0.0+`

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
You can use these [options](#options) to customize the statusline's appearance in `zpreztorc` as follows: `zstyle ':prezto:module:prompt' theme 'statusline' <options>`

Segments are easy to add and remove, just edit the following arrays:
```zsh
_prompt_statusline_left_segments=(status user git-branch directory)
_prompt_statusline_right_segments=(git-status clock history machine)
```

### Features
- **Asynchronous** git status loading
- Task **runtime**
- **Light** and **dark** themes
- **Contextual** segments
- Fully **modular** design
- Custom `PS1`, `RPS1`, `PS2`, `RPS2`, `PS3`, `PS4`, `SPROMPT`, and completion formatting
- **Dual-** and **single-line** prompts
- **Powerline** and **legacy font** support
- Tmux compatible

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

## Options
| Option       | Parameters          | Description                    |
| ------------ | ------------------- | ------------------------------ |
| -c, --color  | Terminal color code | Set statusbar background color |
| -d, --dark   | N/A                 | Apply dark theme               |
| -f, --font   | See below           | Change special chars used      |
| -s, --single | N/A                 | Fit the prompt to one line     |

| Font Parameter | Characters |
| -------------- | :--------: |
| powerline      |  ⮂   ⮀   |
| legacy         |  ◀ < > ▶︎   |
| block          |  ◼ \| \| ◼   |
| none           |     N/A    |
Run `prompt -h statusline` for more information.
