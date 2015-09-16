### Warning
vared -p "This script will clear your ~/.tmux.conf.local. Ok? (yn): " -c clear
if [ $clear != 'y' ]; then
  printf "Exiting\n"
  exit 0
fi

cd ~
#####
# Apple defaults
#####
# Change key repeat speed
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 12

# Disable character accent selector on key hold (most common on vowels)
defaults write -g ApplePressAndHoldEnabled -bool false

# Set alert volume to 0
osascript -e "set volume alert volume 0"
##### END Apple Defaults

# zshell
chsh -s $(which zsh) > /dev/null 2>&1

# Install xcode
xcode-select --install > /dev/null 2>&1 || echo "Xcode already installed"

# Install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /dev/null 2>&1 || echo "Homebrew already installed"

# Install rbenv
brew update
brew install rbenv ruby-build

# Thoughtbot's dotfiles
git clone git://github.com/thoughtbot/dotfiles.git
brew tap thoughtbot/formulae
brew install rcm
env RCRC=$HOME/dotfiles/rcrc rcup
rcup

# Powerline for zshell
if ! grep -q "_update_ps1()" ~/.zshrc.local; then
  cd ~/.zsh
  if ! git clone https://github.com/carlcarl/powerline-zsh 2>&1; then
    echo "powerline-zsh already exists"
  fi
cat <<EOT >> ~/.zshrc.local

# https://github.com/carlcarl/powerline-zsh
export TERM="xterm-256color"
function _update_ps1() {
  export PROMPT="\$(~/.zsh/powerline-zsh/powerline-zsh.py \$?)"
}
precmd()
{
  _update_ps1
}
EOT
  echo "Powerline for Zsh added"
else
  echo "Powerline for Zsh already present"
fi

# Powerline for vim
brew install python
pip install https://github.com/Lokaltog/powerline/tarball/develop

if ! grep -q "plugin/powerline.vim" ~/.vimrc; then
cat <<EOT >> ~/.vimrc.local
source /usr/local/lib/python2.7/site-packages/powerline/bindings/vim/plugin/powerline.vim
set laststatus=2
EOT
  echo "powerline.vim installed"
else
  echo "powerline.vim already installed"
fi

# Powerline patched fonts
echo "Patching powerline fonts"
rm -Rf ~/fonts
git clone https://github.com/powerline/fonts ~
zsh fonts/install.sh

# ~/.tmux.conf.local
brew install reattach-to-user-namespace
touch ~/.tmux.conf.local
rm ~/.tmux.conf.local

cat <<EOT >> ~/.tmux.conf.local
### from https://robots.thoughtbot.com/tmux-copy-paste-on-os-x-a-better-future
setw -g mode-keys vi

# Setup 'v' to begin selection as in Vim
bind-key -t vi-copy v begin-selection
bind-key -t vi-copy y copy-pipe "reattach-to-user-namespace pbcopy"

# Update default binding of `Enter` to also use copy-pipe
unbind -t vi-copy Enter
bind-key -t vi-copy Enter copy-pipe "reattach-to-user-namespace pbcopy"

# New window with default path set to last path
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"
EOT
echo "Installed ~/.tmux.conf.local"

# vim y and p between iterm2 sessions (after restart)
if ! grep -q 'clipboard+=unnamed' ~/.vimrc; then
  echo "set clipboard+=unnamed" >> ~/.vimrc
  echo "clipboard=unnamed set in .vimrc"
else
  echo "clipboard=unnamed already set in .vimrc"
fi

# Persistent undo in vim
if [ ! -d ~/.vim/undodir ]; then
  mkdir ~/.vim/undodir
cat <<EOT >> ~/.vimrc.local

set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000
EOT
  echo "Set up persistent undo in vim"
else
  echo 'undodir already in .vimrc.local'
fi

#####
# Vim Plugins
#####
# Make sure ~/.vimrc.bundles.local exists
touch ~/.vimrc.bundles.local

# Function to check if bundle is installed
check_in_bundles() {
  if grep -q "$1" ~/.vimrc.bundles.local; then
    echo "$1 already installed"
  else
    echo "Plug '$1'" >> ~/.vimrc.bundles.local
    echo "$1 added to ~/.vimrc.bundles.local"
  fi
}

# Install vim-snippets
check_in_bundles 'tomtom/tlib_vim'
check_in_bundles 'MarcWeber/vim-addon-mw-utils'
check_in_bundles 'garbas/vim-snipmate'
check_in_bundles 'honza/vim-snippets'

# Install nerdtree
check_in_bundles 'scrooloose/nerdtree'

# Install vim-go
check_in_bundles 'fatih/vim-go'
##### END Vim Plugins

# Git config
git config --global user.name "Thomas Brigham"
git config --global user.email "thomas@thomasbrigham.me"

echo "Before restart, this script is telling you to change your iTerm2 font! The
settings can be found below this echo statement"
echo "Setup Iterm2 > Preferences > Profiles > Text to have font 14pt Source
Code Pro medium, vertical 1.0 and horizontal 0.8"


# Reboot
vared -p "Restart comp (for settings)? (yn): " -c restart
if [ $restart = 'y' ]; then
  printf "Enter password to reboot...\n"
  sudo reboot
else
  echo "NOTE: YOU MUST REBOOT FOR SEVERAL OF THE CHANGES TO TAKE EFFECT"
fi
