Statusline
===========

![Screenshot](images/screenshot.png)

###A Powerline theme for prezto and oh-my-zsh

This theme requires the powerline-patched menlo font, included [here.](setup/MenloforPowerline-Regular.otf) You can find the dotfiles I use [here.](../dotfiles) Statusline is designed for solarized, and is compatible with the default OS X Terminal.app. This repo also contains [light](setup/Solarized\ Light.terminal) and [dark](setup/Solarized\ Dark.terminal) Terminal.app profiles. The prezto version is up to date; however, the oh-my-zsh version may not receive further updates. Only zsh 5.0.0+ and git 2.0.0+ are supported.

##[Prezto](https://github.com/sorin-ionescu/prezto)
The [prezto version](prezto/prompt_statusline_setup) is more optimized for zsh than the other version and runs much faster. It also shows additional git information, among other enhancements. Since it uses the prezto git and editor modules, it is not compatible with oh-my-zsh. However, I recommend prezto over oh-my-zsh because of faster prompt loading and less startup time.

###Features
- Asynchronous git status loading
- Task runtime
- Light and dark solarized themes
- Contextual segments
- Modular design
- Custom `PS1`, `RPS1`, `PS2`, `RPS2`, `PS3`, `PS4`, `SPROMPT`, and completion formatting
- Tmux support

###Segments
- Exit status/running jobs: shows indicator for previous task
- Username: when in remote shell
- Git branch/position/commit and status: when inside git repository
- Directory: dynamically truncated when too long
- Time: 12-hour clock
- History number: index of current line in zsh history
- Machine name: when in remote shell

###Installation
Simply run this in your shell:
```zsh
zsh "$(curl -fsSL https://raw.githubusercontent.com/el1t/statusline/master/prezto/install)"
```
[Manual installation](prezto/README.md)

##[Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
The [oh-my-zsh version](oh-my-zsh/statusline.zsh-theme) works without formatting errors found in previous agnoster themes, and has more git information and features compared to the original. I have attempted to optimize checking in large git repos. (In oh-my-zsh, make sure `DISABLE_UNTRACKED_FILES_DIRTY` is set to `true` in your `.zshrc` file for faster performance!)

NOTE: Mercurial support is untested and only for the oh-my-zsh version. The custom patched characters can be replaced with typical powerline patched ones, if you so choose; just edit the `_prompt_statusline_separator` variables at the top of the script.
