#!/usr/bin/env sh

[ -z "$install_path" ] && install_path=$HOME/.local/bin
[ -z "$root" ] && root=0

## colors
### use RED color for unsuccessful operations or else
RED='\033[0;31m'
### use GREEN color for successful operations
GREEN='\033[1;32m'
### file related operations
YELLOW='\033[1;33m'
### use BLUE color for script operations
BLUE='\033[0;34m'
### color when installing fm6000
CYAN='\033[0;36m'
### clear colors
NC='\033[0m'

if [ -f "fm6000.pl" ]; then
    printf '%b\n' "${BLUE}Seems like you cloned the repository${NC}"
    cp fm6000.pl fm6000
else
    url="https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/fm6000.pl"
    if [ "$(command -v curl)" ]; then
        printf '%b\n' "${BLUE}Downloading the script${NC}"
        curl $url -o fm6000
    else
        printf '%b\n' "${RED}curl is required${NC}" && exit 1
    fi
fi

if [ "$(command -v doas)" ]; then
    sudo=doas
else
    sudo=sudo
fi

if [ -f "fm6000" ] && [ -s "fm6000" ]; then
    chmod +x fm6000 && printf '%b\n' "${BLUE}Making the script executable : ${GREEN}done"
    require_text="root required"

    if [ -x $install_path ]; then
        if [ $root = 0 ]; then
          require_text="root not required"
          sudo=
        fi
        printf '%b' "${YELLOW}"
        read -p "Move the script to $install_path [$require_text]? (y/N) " ans
    else
        install_path=/usr/local/bin
        printf '%b' "${YELLOW}"
        read -p "Move the script to $install_path [$require_text]? (y/N)  " ans
    fi

    if [ "${ans}" = "y" ]; then
        printf '%b\n' "${BLUE}Moving fm6000 to $install_path${NC}"
        printf '%b' "${CYAN}"
			  $sudo mv -v fm6000 $install_path || ( printf '%b\n' "${RED}error: $sudo failed${NC}"; exit; exit 1 ) # double exit. first one exits the function
        printf '%b\n' "${GREEN}Fetch-master-6000 is successfully installed${NC}"
        exit 0
    else
        printf '%b\n' "${YELLOW}Script not moved!${NC}"
        ./fm6000
        exit 0
    fi
else
    printf '%b\n' "${RED}Unable to download the script${NC}"
fi
