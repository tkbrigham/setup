#####
### FUNCTIONS
#####

### Set color printing functions and current dir
printfBlue() { printf "\e[34m$1" }
printfGreen() { printf "\e[32m$1" }
printfRed() { printf "\e[31m$1" }
resetColor() { printf "\e[0m" }
setup_dir=$(pwd)

### Run a command silently, checking for success
silent_check() {
	printfBlue "  # Running $1..."
	if ($1 > /dev/null 2>&1); then
		printfGreen "DONE\n"
	else
		printfGreen "already installed\n"
	fi
	resetColor
}

#####
### APPLE DEFAULTS
#####

# Change key repeat speed
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

# Disable character accent selector on key hold (most common on vowels)
defaults write -g ApplePressAndHoldEnabled -bool false

#####
### ZSHELL
#####

# Make zshell your shell always
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

# Install pathogen
printfBlue ">> Installing pathogen..."
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
if ! grep -q 'execute pathogen#infect()' ~/.vimrc; then
	printf "execute pathogen#infect()" >> ~/.vimrc
	printfGreen "...DONE\n\n"
else
	printfGreen "already set up\n\n"
fi
resetColor

### Move to vim/bundle for pathogen install of plugins
cd ~/.vim/bundle

### install vim-snipmate: https://github.com/garbas/vim-snipmate
printfBlue ">> Installing vim-snipmate...\n"
printfBlue "-------------\n"
silent_check "git clone https://github.com/tomtom/tlib_vim.git"
silent_check "git clone https://github.com/MarcWeber/vim-addon-mw-utils.git"
silent_check "git clone https://github.com/garbas/vim-snipmate.git"
silent_check "git clone https://github.com/honza/vim-snippets.git"
printfBlue "-------------\n"
### install snippets: https://github.com/honza/vim-snippets/tree/master/snippets

printfGreen "DONE\n\n"



## Vetted:
# 1. SnipMate - Ruby, HAML, javascript, CSS, vim, zsh, Go?
# 2. BufExplorer (lanzarotta)
# 3. NERDTREE (grenfell)
# 4. Easy Motion
# 5. Surround
# 6. Matchit (benji fischer)
# 7. Fugitive
# 8. vim rails
# 9. vim rubocop
# 10. vim syntastic
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

