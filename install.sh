#!/usr/bin/env bash



[ -z "$install_path" ] && install_path=$HOME/.local/bin
[ -z "$root" ] && root=0

## colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

if [ -f "fm6000.pl" ]; then
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

if [ -f "fm6000" ] && [ -s "fm6000" ]; then
    chmod +x fm6000
    echo "Making the script executable : done"
    if [ -x $install_path ]; then
				if [ $root = 0 ]; then
					require_text="root not required"
					sudo=
				else
					require_text="root required"
				fi
        read -p "Move the script to $install_path [$require_text]? (y/N) " ans
    else
        install_path=/usr/local/bin
        read -p "Move the script to $install_path [root required]? (y/N) " ans
    fi

    if [ "${ans}" = "y" ]; then
        echo "Moving fm6000 to $install_path"
        $sudo mv -v fm6000 $install_path || printf '%s\n' "error: $sudo failed" && exit 1
    else
        echo "Script not moved"
        ./fm6000
        exit
    fi
    echo "Fetch-master-6000 is succesfully installed"
else
    echo "Unable to download the script"
fi
