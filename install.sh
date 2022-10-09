#!/usr/bin/env sh

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

out() {
	# Print a message
	printf '%b\n' "$@"
}

notset() {
	case $1 in '') return 0 ;; *) return 1 ;; esac
}

check_dep() {
	if [ "$(command -v "$1")" ]; then return 0; else return 1; fi
}

## get options
for opt in "$@"; do
	case $opt in
	--nocolors | -nc)
		# unset colors
		for i in RED GREEN YELLOW BLUE CYAN NC; do
			unset $i
		done
		;;
	--root | -r)
		root=1
		;;
	--no*root | -nr)
		root=0
		;;
	--install*path=*)
		install_path="${opt#*=}"
		;;
	--dry*run | -dr)
		dryrun=1
		;;
	--headless | -y)
		headless=1
		;;
	-h | *)
		[ -x "./install.sh" ] && prog="./install.sh" || prog="sh -c \"\$(curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/install.sh)\""
		out \
			"${RED}------${NC} ${CYAN}Fetch-Master-6000 install script${NC} ${RED}------${NC}
${YELLOW}Usage:${NC} $prog ${BLUE}<options>${NC}

 ${RED}--nocolors${NC},${RED} -nc    ${GREEN}Do not print colored text${NC}
 ${RED}--root${NC},${RED}     -r     ${GREEN}Use root privileges(it is automatically detected but still can be used)${NC}
 ${RED}--noroot${NC},${RED}   -nr    ${GREEN}Do not use root privileges(it is automatically detected but still can be used)${NC}
 ${RED}--dry-run${NC},${RED}  -dr    ${GREEN}Dry run fm6000${NC}
 ${RED}--headless${NC},${RED} -y     ${GREEN}install headless(without prompting)${NC}
"
		exit 1
		;;
	esac
done

# make script compatible with env variables

## set install_path
notset "$install_path" && {
	if [ -x "$HOME/.local/bin" ]; then
		install_path=$HOME/.local/bin
	elif [ -x "/usr/local/bin" ]; then
		install_path=/usr/local/bin
	fi
}

## check if $install_path requires root group
notset "$install_path" || {
	[ ! -x "$install_path" ] && {
		out "${RED}$install_path does not exist${NC}"
		return 1
	}
	check_dep "stat" && {
		if [ "$(stat -c "%G" $install_path)" = "root" ]; then
			notset "$root" && root=1
		fi
	}
}

## fix when env var root=0 is set
[ "$root" = "0" ] && root=

## root text and else
if notset "$root"; then
	require_text="root not required"
	sudo=
else
	require_text="root required"
fi

## set headless when it is not already set
notset "$headless" && headless=

## download fm6000 if it does not exist
if [ -f "fm6000.pl" ]; then
	out "${BLUE}Seems like you cloned the repository${NC}"
	cp fm6000.pl fm6000
else
	url="https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/fm6000.pl"
	if check_dep "curl"; then
		out "${BLUE}Downloading the script${NC}"
		curl $url -o fm6000
	else
		out "${RED}curl is required${NC}" && return 1
	fi
fi

if ! notset "$root"; then
	## if user is root do not set sudo
	if [ "$(id -u)" -eq "0" ]; then
		sudo=
	## check if doas is available
	elif [ "$(command -v doas)" ]; then
		sudo=doas
	## if user is not root and doas is not found fallback to sudo
	else
		sudo=sudo
	fi
fi

if [ -f "fm6000" ] && [ -s "fm6000" ]; then
	chmod +x fm6000 && out "${BLUE}Making the script executable : ${GREEN}done"

	# shellcheck disable=SC2086
	if check_dep "find" && [ "$(find /usr/bin /usr/local/bin $HOME/.local/bin -type f -iname 'fm6000' 2>/dev/null)" ]; then
		out "${RED}it seems fm6000 is already installed but continuing anyway${NC}"
	fi

	notset "$dryrun" && notset "$headless" && {
		printf '%b' "${YELLOW}Move the script to $install_path [${RED}$require_text${YELLOW}]? (y/N) "
		read -r ans
	}

	case $ans in
	y | Y | -y | -Y)
		ans="y"
		;;
	*)
		ans="N"
		;;
	esac

	if [ "$headless" = "1" ] || [ "$ans" = "y" ]; then
		out "${BLUE}Moving fm6000 to $install_path${NC}"
		printf '%b' "${CYAN}"
		$sudo mv -v fm6000 $install_path || {
			out "${RED}error: $sudo failed${NC}"
			exit 1
		}
		out "${GREEN}Fetch-master-6000 is successfully installed${NC}"
		exit 0
	else
		out "${YELLOW}Script not moved!${NC}"
		./fm6000
		exit 0
	fi
else
	out "${RED}Unable to download the script${NC}"
fi
