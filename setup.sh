# Change key repeat speed
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

# Disable character accent selector on key hold (most common on vowels)
defaults write -g ApplePressAndHoldEnabled -bool false

# Make zshell your shell always
if [ 'echo $0'='-zsh' ]; then
	printf 'Shell already set to zshell\n'
else
	chsh -s /bin/zsh
fi

mkdir -p ~/code
cd ~/code

# Install xcode-select
if ! type "xcode-select" > /dev/null; then 
	printf "Installing xcode-select..."
	xcode-select --install
	echo "done"
else
	echo "xcode-select already installed"
fi

# Install pathogen
printf "Installing pathogen..."
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
if ! grep -q 'execute pathogen#infect()' ~/.vimrc; then
	printf "execute pathogen#infect()" >> ~/.vimrc
	echo "done"
else
	printf "already set up\n"
fi

# Add Tim Pope's super minimal vim settings from github.com/tpope/vim-pathogen
printf "Installing Tim Pope's minimal vim settings..."
if grep -q 'filetype plugin indent on' ~/.vimrc; then
	printf "\nsyntax on\nfiletype plugin indent on" >> ~/.vimrc
	printf "done\n"
else
	printf "already installed\n"
fi

# Add vim-sensible
printf "Installing vim-sensible..."
if cd ~/.vim/bundle/vim-sensible; then
	printf "vim-sensible already exists\n"
else
	cd ~/.vim/bundle/vim-sensible
	git clone git://github.com/tpope/vim-sensible.git
	cd ~/code
	echo "done"
fi

# Install pretzo, a replacement for oh-my-zsh
printf "Installing pretzo..."
if cd ~/.zprezto; then
	printf "~/.zprezto exists!\n"
else
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	zsh ~/prezto_config.sh
	echo "AFTER PREZTO"
fi

## MUST RESTART FOR KEYSTROKE REPEAT TO WORK
