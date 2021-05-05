#!/usr/bin/env bash

url="https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/fm6000.pl"
if [[ $(command -v curl) ]]; then
    echo "Downloading the script"
    curl $url -o fm6000
elif [[ $(command -v wget) ]]; then
    echo "Downloading the script"
    wget $url -O fm6000
else
    echo "curl or wget is required" && exit
fi

if [[ -f "fm6000" && -s "fm6000" ]]; then
    chmod +x fm6000
    echo "Making the script executable : done"
    read -p "Move the script to /usr/local/bin/ [root required]? (y/N) " ans
    if [[ "${ans,,}" == "y" ]]; then
        echo "Moving fm6000 to /usr/local/bin/"
        if [[ $(command -v doas) ]]; then
            doas mv fm6000 /usr/local/bin/
        else
            sudo mv fm6000 /usr/local/bin/
        fi
    else
        echo "Script not moved"
        ./fm6000
    fi
    echo "Fetch-master-6000 is succesfully installed"
else
    echo "Unable to download the script"
fi

