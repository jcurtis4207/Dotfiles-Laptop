distro=ARCH
user=jacob

alias ..="cd .."
alias ...="cd ../.."

alias cp="cp -i" # prompt before overwrite
alias mv="mv -i"
alias rm="rm -i"
alias ls="ls -hlN --color=auto --group-directories-first" # human-readable, list view, no quotes
alias la="ls -hNA --color=auto" # human-readable, no quotes, list all but '.' and '..'
alias ps="ps aux" # all user processes, show user/owner, all processes not run by terminal
alias du="du -h -d 1" # human readable and 1 directory deep
alias mkdir="mkdir -p" # create parents as needed
alias sudovim="sudo -E vim" # run vim as sudo with user settings and plugins
alias shutdown="/sbin/shutdown -h now"
alias snip="scrot -s /home/$user/Pictures/%Y-%m-%d_%H:%M:%S_scrot.png" # select window, move to Pictures

# git bare repositories
alias dotfiles="/usr/bin/git --git-dir=/home/$user/Git/Dotfiles-Laptop --work-tree=/home/$user"
alias scripts="/usr/bin/git --git-dir=/home/$user/Git/Scripts --work-tree=/home/$user"

# package management
function update {
    if [ $distro = ARCH ];then
            sudo pacman -Syy
    elif [ $distro = DEBIAN ];then
            sudo apt-get update
    else
            echo "Distro Not Recognized"
    fi
}
function upgrade {
    if [ $distro = ARCH ];then
            sudo pacman -Syu; echo "paru -Sua for AUR packages"
    elif [ $distro = DEBIAN ];then
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

# archive extraction
function extract {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"   ;;
            *.zip)       unzip "$1"     ;;
            *.Z)         uncompress "$1";;
            *.7z)        7z x "$1"      ;;
            *.deb)       ar x "$1"      ;;
            *.tar.xz)    tar xf "$1"    ;;
            *.tar.zst)   unzstd "$1"    ;;
            *)           echo "'$1' cannot be extracted via ex()"  ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi

    # if no errors, delete input archives
    if [ $? -eq 0 ]
    then
        # if multiple parts, delete all parts
        if [[ $1 == *part[0-9]* ]]
        then
            target="${1/part[0-9]*/part}"
            rm -i "$target"*
        else
            rm -i "$1"
        fi
    else
        echo "ERROR"
    fi
}
