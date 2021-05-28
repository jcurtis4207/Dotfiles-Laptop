distro=ARCH
user=jacob

# My Bash Aliases
alias ..="cd .."
alias ...="cd ../.."

alias cp="cp -i" # prompt before overwrite
alias mv="mv -i"
alias rm="rm -i"
alias df="df -h" # human readable
alias ls="ls -hlN --color=auto --group-directories-first" # human-readable, list view, no quotes
alias la="ls -hNA --color=auto" # human-readable, no quotes, list all but '.' and '..'
alias ps="ps aux" # all user processes, show user/owner, all processes not run by terminal
alias vi="vim"
alias sudovim="sudo -E vim" # run vim as sudo with user settings and plugins
alias mkdir="mkdir -p" # create parents as needed
alias shutdown="sudo shutdown -h now"

alias snip="scrot -s /home/$user/Pictures/%Y-%m-%d_%H:%M:%S_scrot.png" # select window, move to Pictures
alias random="shuf -ezn 1 * | xargs -0 -n1 vlc" # play random video in current directory

# alias for git bare repository
alias dotfiles="/usr/bin/git --git-dir=/home/$user/Git/Dotfiles-Laptop --work-tree=/home/$user"
alias scripts="/usr/bin/git --git-dir=/home/$user/Git/Scripts --work-tree=/home/$user"

# disposable alias for installing vundle
# alias zzzzzzz="git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"

function update {
    if [ $distro = ARCH ];then
            sudo pacman -Syu
    elif [ $distro = DEBIAN ];then
            sudo apt-get update
    else
            echo "Distro Not Recognized"
    fi
}
function upgrade {
    if [ $distro = DEBIAN ];then
            sudo apt-get dist-upgrade --yes --auto-remove
    else
            echo "Distro Not Recognized"
    fi
}
function install {
    if [ $distro = ARCH ];then
            sudo pacman -S $@
    elif [ $distro = DEBIAN ];then
            sudo apt-get install -y $@
    else
            echo "Distro Not Recognized"
    fi
}
function remove {
    if [ $distro = ARCH ];then
            sudo pacman -Rsn $@
    elif [ $distro = DEBIAN ];then
            sudo apt-get remove --purge --yes --auto-remove $@
    else
            echo "Distro Not Recognized"
    fi
}
