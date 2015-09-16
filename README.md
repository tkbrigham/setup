# Setup Script
This is intended to be a script that can be run multiple times without
breaking/hurting anything. The script should set up basic configurations for a
variety of tools/configs, explained below.

The script assumes you have a Mac and have installed Iterm2.


## Apple defaults
1. Speed up key repeat speed
2. Speed up when repeat starts
3. Disable the weird Mac accent selector when a key is held
4. Set annoying alert volume to 0

## Zshell
Set shell to zsh

## xcode, homebrew, rbenv
Required for anything useful

## thoughtbot's dotfiles
https://github.com/thoughtbot/dotfiles

## Powerline for zsh and vim
Provides sexy colors, admittedly at a speed cost. Adds configs to .zshrc and
.vimrc.

## Iterm2
__NOT SCRIPTED__: Manually set Iterm2 > Preferences > Profiles > Text to 14pt
Source Code Pro medium, vertical 1.0 & horizontal 0.8

## Tmux
1. __RESETS ~/.tmux.conf.local -- CAUTION__
2. Make Tmux to copy/paste/play nice with OS X: https://robots.thoughtbot.com/tmux-copy-paste-     on-os-x-a-better-future
3. Opening a new window opens inside the same directoryj

## Vim
1. Persistent undo: http://amix.dk/blog/post/19548
2. yank (y) and paste (p) between Iterm2 windows!!!!
3. Beyond thoughtbot's plugins, also install:
  * vim-snippets
  * nerdtree
  * vim-go

## Git
Set user.name and user.email globally to me.

If your.name != "Thomas Brigham", find the lines with "git config" and update
accordingly.

## Reboot
After all commands are run, the script will prompt for a reboot, which is
necessary for some of the settings/updates.
