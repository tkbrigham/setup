### Set up colors and setup directory
printfBlue() { printf "\e[34m$1" }
printfGreen() { printf "\e[32m$1" }
resetColor() { printf "\e[0m" }
setup_dir=$(pwd)

# Change key repeat speed
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

# Disable character accent selector on key hold (most common on vowels)
defaults write -g ApplePressAndHoldEnabled -bool false

# Make zshell your shell always
printfBlue '>> Setting shell to zshell...'
if [ 'echo $0'='-zsh' ]; then
	printfBlue 'already set\n'
else
	chsh -s /bin/zsh
	printfGreen 'done'
fi
resetColor

### Install xcode-select
printfBlue ">> Installing xcode-select..."
if ! type "xcode-select" > /dev/null; then 
	xcode-select --install
	printfGreen "...done\n"
else
	printfBlue "already installed\n"
fi
resetColor

# Install pathogen
printfBlue ">> Installing pathogen..."
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
if ! grep -q 'execute pathogen#infect()' ~/.vimrc; then
	printf "execute pathogen#infect()" >> ~/.vimrc
	printfGreen "...done\n"
else
	printfBlue "already set up\n"
fi
resetColor

# Add Tim Pope's super minimal vim settings from github.com/tpope/vim-pathogen
printfBlue ">> Installing Tim Pope's minimal vim settings..."
if ! grep -q 'filetype plugin indent on' ~/.vimrc; then
	printf "\nsyntax on\nfiletype plugin indent on" >> ~/.vimrc
	printfGreen "...done\n"
else
	printfBlue "already installed\n"
fi
resetColor

# Add vim-sensible
printfBlue ">> Installing vim-sensible..."
if cd ~/.vim/bundle/vim-sensible; then
	printfBlue "already installed\n"
else
	cd ~/.vim/bundle/vim-sensible
	git clone git://github.com/tpope/vim-sensible.git
	cd ~/code
	printfGreen "...done\n"
fi
resetColor

### TODO: ADD OTHER .VIMRC THINGS HERE

# Install pretzo, a replacement for oh-my-zsh
printfBlue ">> Installing ~/.zpretzo..."
if [ -d ~/.zprezto ]; then
	printfBlue "already exists\n"
else
	resetColor
	echo ""
	git clone --quiet --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	cd $setup_dir
	zsh run/prezto_config.sh
	printfGreen "...done\n"
fi
resetColor

### TODO: UPDATE PRETZO SETTINGS FOR SHELL NAV

### TODO: ITERM2 PREFERENCES - SET, SAVE, AND LOAD INTO FOLDER

### TODO: RESTART TERMINAL

### TODO: github keys??





## MUST RESTART FOR KEYSTROKE REPEAT TO WORK
