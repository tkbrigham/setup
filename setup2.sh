### If anything fails, let the console know
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

### Set current dir
setup_dir = $(pwd)

### Change key repeat speed
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

### Disable character accent selector on key hold (most common on vowels)
defaults write -g ApplePressAndHoldEnabled -bool false

### Make zshell your shell always
chsh -s /bin/zsh

### Install xcode-select
if ! type "xcode-select" > /dev/null; then
	xcode-select --install
fi

### Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

### thoughtbot dotfiles
cd ~
git clone git://github.com/thoughtbot/dotfiles.git
brew tap thoughtbot/formulae
brew install rcm
env RCRC=$HOME/DOTFILES/rcrc rcup

# Install pretzo, a replacement for oh-my-zsh
if [ ! -d ~/.zprezto ]; then
  git clone --quiet --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  echo $setup_dir
  cd $setup_dir
  zsh run/prezto_config.sh
fi

### Install powerline for prezto
# Install YADR
git clone https://github.com/skwp/dotfiles ~/.yadr
cd ~/.yadr && rake install

# Create a ~/.secrets file (required by YADR)
touch ~/.secrets

# Install the prompt
curl https://raw.github.com/davidjrice/prezto_powerline/master/prompt_powerline_setup > ~/.zsh.prompts/prompt_powerline_setup

# Install Solarized
git clone https://github.com/altercation/solarized
cd solarized

# e.g. for iTerm
cd iterm2-colors-solarized/
open Solarized\ Dark.itermcolors
# this should load the colours for iTerm, but they are not configured yet

echo "CHECK LINE 61 for iterm preferences!!!"
# in iTerm2 open preferences 
#   profiles > default > colours > load presets > Solarized Dark
#   profiles > default > terminal > report terminal type > "xterm-256color"

# Enable
echo "prompt powerline" > ~/.zsh.after/prompt.zsh
