### If anything fails, let the console know
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

#####
### FUNCTIONS
#####

### Set color printing functions and current dir
printfBlue2() { printf "\e[36m$1" }
printfBlue() { printf "\e[34m$1" }
printfGreen() { printf "\e[32m$1" }
printfRed() { printf "\e[31m$1" }
resetColor() { printf "\e[0m" }
setup_dir=$(pwd)

### Run a command silently, checking for success
silent_check() {
	eval $1 > /dev/null 2>&1
	resetColor
}

quiet_check() {
	eval $1 > /dev/null 2>&1
	ret=$?
	if [ $ret = 0 ]; then
		printfGreen "DONE\n"
	else
		printfGreen "already installed\n"
	fi
	resetColor
}

noisy_check() {
	printfBlue2 "    # "
	printfBlue "Running $1..."
	eval $1 > /dev/null 2>&1
	ret=$?
	if [ $ret = 0 ]; then
		printfGreen "DONE\n"
	else
		printfGreen "already installed\n"
	fi
	resetColor
}

### Change key repeat speed
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

### Disable character accent selector on key hold (most common on vowels)
defaults write -g ApplePressAndHoldEnabled -bool false

### Make zshell your shell always
printfBlue '>> Setting shell to zshell...'
if [ 'echo $0'='-zsh' ]; then
	printfGreen 'already set\n\n'
else
	chsh -s /bin/zsh
	printfGreen 'DONE'
fi
resetColor

### Install xcode-select
printfBlue ">> Installing xcode-select..."
if ! type "xcode-select" > /dev/null; then 
	xcode-select --install
	printfGreen "...DONE\n\n"
else
	printfGreen "already installed\n\n"
fi
resetColor

### Install Homebrew
printfBlue "Installing Homebrew...\n"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

### thoughtbot dotfiles
printfBlue "Installing thoughtbot dotfiles...\n"
cd ~
git clone git://github.com/thoughtbot/dotfiles.git
brew tap thoughtbot/formulae
brew install rcm
env RCRC=$HOME/DOTFILES/rcrc rcup

#####
### Prezto
#####

# Install pretzo, a replacement for oh-my-zsh
printfBlue ">> Installing ~/.zpretzo..."
if [ -d ~/.zprezto ]; then
	printfGreen "already exists\n\n"
else
	resetColor
	git clone --quiet --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	cd $setup_dir
	zsh run/prezto_config.sh
	printfGreen "...DONE\n\n"
fi
resetColor

#####
### VIM 
#####

printfBlue2 "##########\n"
printfBlue2 "###### VIM CONFIGS\n"
printfBlue2 "##########\n\n"

# Install pathogen
printfBlue ">> Installing pathogen..."
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
if ! grep -q 'execute pathogen#infect()' ~/.vimrc; then
	printf "execute pathogen#infect()" >> ~/.vimrc
	printfGreen "DONE\n\n"
else
	printfGreen "already set up\n\n"
fi
resetColor

### Move to vim/bundle for pathogen install of plugins
cd ~/.vim/bundle

### install vim-snipmate: https://github.com/garbas/vim-snipmate
printfBlue ">> Installing vim-snipmate...\n"
noisy_check "git clone https://github.com/tomtom/tlib_vim.git"
noisy_check "git clone https://github.com/MarcWeber/vim-addon-mw-utils.git"
noisy_check "git clone https://github.com/garbas/vim-snipmate.git"
noisy_check "git clone https://github.com/honza/vim-snippets.git"

printfBlue "\n>> Installing bufexplorer..."
quiet_check "git clone https://github.com/jlanzarotta/bufexplorer"

printfBlue "\n>> Installing NERDtree..."
quiet_check "git clone https://github.com/scrooloose/nerdtree.git"
# TODO: nerdtree-git-plugin not installed

printfBlue "\n>> Installing vim-repeat..."
quiet_check "https://github.com/tpope/vim-repeat"

printfBlue "\n>> Installing vim-easymotion..."
quiet_check "git clone https://github.com/easymotion/vim-easymotion"
# TODO: tutorial at http://code.tutsplus.com/tutorials/vim-essential-plugin-easymotion--net-19223

printfBlue "\n>> Installing vim-surround..."
quiet_check "git clone git://github.com/tpope/vim-surround.git"

printfBlue "\n>> Installing vim-fugitive..."
quiet_check "git clone git://github.com/tpope/vim-fugitive.git"
vim -u NONE -c \"helptags vim-fugitive/doc\" -c q

printfBlue "\n>> Installing vim-rails..."
silent_check "git clone git://github.com/tpope/vim-rails.git"
quiet_check "git clone git://github.com/tpope/vim-bundler.git"

# 10. vim rubocop
# 11. vim speeddating
# 12. powerline
# 13. Ctrl-P
# set <leader> to single space
# vim-mkdir
# solarized - iterm and vim
# supertab (ervandrew)



### TODO: UPDATE PRETZO SETTINGS FOR SHELL NAV
# shell https://github.com/davidjrice/prezto_powerline

### TODO: tmux??

### TODO: ITERM2 PREFERENCES - SET, SAVE, AND LOAD INTO FOLDER

### TODO: RESTART TERMINAL

### TODO: github keys??

## MUST RESTART FOR KEYSTROKE REPEAT TO WORK

