# Script to uninstall thoughtbot dotfiles and symlinks, and also remove the
# ~/fonts directory that is installed by the install.sh script

# If it is desirable to remove locals
locals=(.aliases.local
  .gitconfig.local
  .gvimrc.local
  .psqlrc.local
  .tmux.conf.local
  .vimrc.bundles.local
  .vimrc.local
  .zshenv.local
  .zshrc.local)

# Assumes that dotfiles repo and all symlinks are in ~
dotfiles=(.agignore
  .aliases
  .gemrc
  .gitconfig
  .gitignore
  .gitmessage
  .gvimrc
  .hushlogin
  .psqlrc
  .rbenv
  .rcrc
  .rspec
  .tmux.conf
  .vimrc
  .vimrc.bundles
  .zshenv
  .zshrc
  dotfiles
  fonts)


echo "DANGER: WILL DELETE THE FOLLOWING:"
for i in "${dotfiles[@]}"; do
  echo $i
done
vared -p "Ok to proceed? (yn): " -c delete
if [ $delete != 'y' ]; then
  for i in "${dotfiles[@]}"; do
    echo "Erasing $i"
    rm -Rf ~/$i 2>&1
  done
  echo "All dotfiles erased"
fi

echo "Also delete .local configs? They are:"
for i in "${locals[@]}"; do
  echo $i
done
vared -p "Ok to proceed? (yn): " -c delete
if [ $delete != 'y' ]; then
  for i in "${locals[@]}"; do
    echo "Erasing $i"
    rm -Rf ~/$i 2>&1
  done
  echo "All locals erased"
fi
