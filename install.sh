#!/usr/bin/env bash

if [[ -f "fm6000.pl" ]]; then
    echo "Seems like you cloned the repository"
    cp fm6000.pl fm6000
else
    url="https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/fm6000.pl"
    if [[ $(command -v curl) ]]; then
        echo "Downloading the script"
        curl $url -o fm6000
    else
        echo "curl is required" && exit
    fi
fi

if [ "$(command -v doas)" ]; then
    sudo=doas
else
    sudo=sudo
fi

if [[ -f "fm6000" && -s "fm6000" ]]; then
    chmod +x fm6000
    echo "Making the script executable : done"
    if [ -x $HOME/.local/bin ]; then
        install_path=$HOME/.local/bin
        sudo=
        read -p "Move the script to $install_path [root not required]? (y/N) " ans
    else
        install_path=/usr/local/bin
        read -p "Move the script to $install_path [root required]? (y/N) " ans
    fi

    if [[ "${ans,,}" == "y" ]]; then
        echo "Moving fm6000 to $install_path"
        $sudo mv -v fm6000 $install_path
    else
        echo "Script not moved"
        ./fm6000
        exit
    fi
    echo "Fetch-master-6000 is succesfully installed"
else
    echo "Unable to download the script"
fi
