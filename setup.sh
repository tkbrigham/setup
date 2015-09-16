cd ~
###
# Apple defaults
###
# Change key repeat speed
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 12

# Disable character accent selector on key hold (most common on vowels)
defaults write -g ApplePressAndHoldEnabled -bool false

# Set alert volume to 0
osascript -e "set volume alert volume 0"
###

# zshell
chsh -s $(which zsh) > /dev/null 2>&1

# Install xcode
xcode-select --install > /dev/null 2>&1 || echo "Xcode already installed"

# Install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /dev/null 2>&1 || echo "Homebrew already installed"

# Thoughtbot's dotfiles
git clone git://github.com/thoughtbot/dotfiles.git
brew tap thoughtbot/formulae
brew install rcm
env RCRC=$HOME/dotfiles/rcrc rcup
rcup

# Install rbenv
brew update
brew install rbenv ruby-build

# Powerline for zshell
if ! grep -q "_update_ps1()" ~/.zshrc; then
cat <<EOT >> ~/.zshrc

# https://github.com/carlcarl/powerline-zsh
export TERM="xterm-256color"
function _update_ps1() {
  export PROMPT="\$(~/powerline-zsh.py \$?)"
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

# Persistent undo in vim
if [ ! -d ~/.vim/undodir ]; then
  mkdir ~/.vim/undodir
cat <<EOT >> ~/.vimrc

set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000
EOT
  echo "Set up persistent undo in vim"
else
  echo 'undodir already in .vimrc'
fi

# Powerline for vim
brew install python
pip install https://github.com/Lokaltog/powerline/tarball/develop

if ! grep -q "plugin/powerline.vim" ~/.vimrc; then
cat <<EOT >> ~/.vimrc
source /usr/local/lib/python2.7/site-packages/powerline/bindings/vim/plugin/powerline.vim
set laststatus=2
EOT
  echo "powerline.vim installed"
else
  echo "powerline.vim already installed"
fi

## Setup Iterm2 > Preferences > Profiles > Text to have font 14pt Source Code Pro medium, vertical 1.0 and horizontal 0.8
echo "CHECK LINE 77"

# ~/.tmux.conf.local
brew install reattach-to-user-namespace
if [ ! -e ~/.tmux.conf.local ]; then
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
  echo "Installed ~/.tmux.conf.local lines"
else
  echo "~/.tmux.conf.local already present"
fi

# vim y and p between iterm2 sessions (after restart)
if ! grep -q 'clipboard+=unnamed' ~/.vimrc; then
  echo "set clipboard+=unnamed" >> ~/.vimrc
  echo "clipboard=unnamed set in .vimrc"
else
  echo "clipboard=unnamed already set in .vimrc"
fi

# cd into .vim/bundle for vim installs
cd ~/.vim/bundle

echo "current dir is $(pwd)"

# Install vim-snippets
if [ ! -d ~/.vim/bundle/vim-snippets ]; then
  echo "VIM SNIPPETS NOT FOUND"
  git clone https://github.com/tomtom/tlib_vim.git
  git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
  git clone https://github.com/garbas/vim-snipmate.git
  git clone https://github.com/honza/vim-snippets.git
  echo "vim-snippets files installed"
else
  echo "vim-snippets files already installed"
fi

# Install nerdtree
if [ ! -d ~/.vim/bundle/nerdtree ]; then
  echo "VIM NERDTREE NOT FOUND"
  git clone https://github.com/scrooloose/nerdtree.git
  echo "installed nerdtree"
else
  echo "nerdtree already installed"
fi

# Install vim-surround
if [ ! -d ~/.vim/bundle/vim-surround ]; then
  echo "VIM-SURROUND NOT FOUND"
  git clone git://github.com/tpope/vim-surround.git
  echo "installed vim-surround"
else
  echo "vim-surround already installed"
fi

# Install vim-go
if [ ! -d ~/.vim/bundle/vim-go ]; then
  echo "VIM-GO NOT FOUND"
  git clone https://github.com/fatih/vim-go.git
  echo "installed vim-go"
else
  echo "vim-go already installed"
fi

vared -p "Restart comp (for settings)? (yn): " -c restart
if [ $restart = 'y' ]; then
  printf "Enter password to reboot...\n"
  sudo reboot
else
  echo "Not rebooting"
fi
