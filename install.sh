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

# Might as well ask for password up-front, right?
sudo -v

# Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

platform=$(uname);

if [[ $platform == 'Linux' ]]; then
    if `type -p apt-get > /dev/null`; then
        inst_cmd="sudo apt-get -y install"
    elif `type -p yum > /dev/null`; then
        inst_cmd="sudo yum -y install"
    fi
elif [[ $platform == 'Darwin' ]]; then
    if `type -p brew > /dev/null`; then
        inst_cmd="brew install"
    fi
fi

if [ -z "$inst_cmd" ]; then
    echo "UNSET install command"
    exit 13
fi

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

install_zsh () {
# Test to see if zshell is installed.  If it is:
if type -P zsh &> /dev/null; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone http://github.com/robbyrussell/oh-my-zsh.git
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        if [[ $platform == 'Linux' ]]; then
            sudo usermod -s $(which zsh) $USER
        elif [[ $platform == 'Darwin' ]]; then
            sudo chsh -s $(which zsh) $USER
        fi
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    eval "$inst_cmd zsh"
    if [[ $platform == 'Darwin' ]]; then
        echo "`which zsh`" | sudo tee -a /etc/shells
    fi
    install_zsh
fi
}

# The Silver searcher (like ack or grep, but faster)
install_ag () {
if ! type -P ag &> /dev/null; then
    eval "$inst_cmd ag"
fi
}

install_ctags () {
if [[ $platform == 'Linux' ]]; then
    if ! type -P ctags &> /dev/null; then
        eval "$inst_cmd exuberant-ctags"
    fi
elif [[ $platform == 'Darwin' ]]; then
    if ! type -P ctags &> /dev/null; then
        eval "$inst_cmd ctags"
    fi
fi
}

install_cscope () {
if ! type -P cscope &> /dev/null; then
    eval "$inst_cmd cscope"
fi
}

install_flake8 () {
if ! type -P pip &> /dev/null; then
    sudo easy_install pip
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

if ! type -P vim &> /dev/null; then
    read -p "Install vim? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        eval "$inst_cmd vim"
    fi
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

