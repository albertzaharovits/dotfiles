#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="bashrc vimrc vim zshrc oh-my-zsh"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

platform=$(uname);

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /usr/local/bin/zsh -o -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone http://github.com/robbyrussell/oh-my-zsh.git
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        sudo apt-get install zsh
        install_zsh
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        brew install zsh && sudo echo "$(which zsh)" | sudo tee -a /etc/shells
        install_zsh
    fi
fi
}

install_ctags () {
if [[ $platform == 'Linux' ]]; then
    sudo apt-get install exuberant-ctags
elif [[ $platform == 'Darwin' ]]; then
    brew install ctags
fi
}

install_cscope () {
if [[ $platform == 'Linux' ]]; then
    sudo apt-get install cscope
elif [[ $platform == 'Darwin' ]]; then
    brew install cscope
fi
}

install_flake8 () {
    if [ ! $(hash pip) ]; then
        if [[ $platform == 'Linux' ]]; then
            sudo apt-get install python-pip
        elif [[ $platform == 'Darwin' ]]; then
            sudo easy_install pip
        fi
    fi
    pip install flake8
}

install_vundle () {
if [ ! -d $dir/vim/bundle ]; then
    git clone https://github.com/gmarik/Vundle.vim.git $dir/vim/bundle/Vundle.vim
fi
}

read -p "Install zsh? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_zsh
fi

read -p "Install Vundle (VIM plugin manager)? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_vundle
    read -p "Install all Vundle plugins? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        vim +PluginInstall +qall now
    fi
    echo "Some plugins have dependencies, see documentation!"
    echo "Here are some of them:"
    read -p "Install ctags? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_ctags
    fi
    read -p "Install cscope? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_cscope
    fi
    read -p "Install flake8? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_flake8
    fi
fi

