# Fetch-master 6000

## Simple dilbert themed fetching tool for Linux and BSD.

ASCII art of Dilbert is taken from the [Kakoune text editor](https://github.com/mawww/kakoune)
ASCII art of Alice, PHB is taken from [Christopher Johnson's collection](https://asciiart.website/index.php?art=comics/dilbert)
ASCII art of the Wolf is taken from [asciiart.eu](https://www.asciiart.eu/animals/wolves)
ASCII art of the Astronaut is taken from [this site](https://pastebin.com/T7tunPCa)

## Screenshots
![all1.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/all1.png)
![al2l.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/all2.png)
![arts.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/arts.png)

## Installation
Its just a perl script
download it make it executable and put somewhere in your $PATH

**For Gentoo** refer to the [XDream's Repository](https://github.com/XDream8/dreamsrepo)
**For Arch users** its available in the AUR as `fm6000`

## Via install script
```sh
sh -c "$(curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/install.sh)"
```
### install script help page
```sh
sh -c "$(curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/install.sh)" -- -h
```
### install script options
- use --install-path option or set "install_path" variable(this variable defaults to $HOME/.local/bin, if it does not exist /usr/local/bin is used)
- use --root(-r), --noroot(-nr) or set "root" variable(this is automatically detected via stat if "root" var is not set and options are not used)
- use --dry-run(-dr) to dry run fm6000
-
### example
```sh
sh -c "$(curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/install.sh)" -- --install-path=/usr/bin --root
```
**or**
```sh
install_path=/usr/bin root=1 sh -c "$(curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/install.sh)"
```

## Manually
with wget
``` sh
wget https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/fm6000.pl -O fm6000
```
### or
with curl
``` sh
curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/fm6000.pl --output fm6000
```
making it executable
```sh
chmod +x fm6000
```
copying it to $PATH (~/.local/bin/ , this step is optional)
```sh
cp fm6000 ~/.local/bin/
```

## Usage
if fm6000 in $PATH
```bash
fm6000
```
runing the script
```bash
./fm6000
```
or
```bash
perl fm6000
```
or
```bash
bash fm6000
```

## Displaying custom ASCII from file
```bash
fm6000 -f arch_logo.txt
```
![arch_logo.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/arch_logo.png)

### About custom ascii_art file
every line should be of same length (use spaces if needed)
atleast 10 lines is required (use empty spaces lines if needed)

## Say
```bash
fm6000 -say "Hello world!"
```
![say.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/say.png)

## Geometry
![geometry.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/geometry.png)

## Available Options
**-c** or **--color=STR** Base color
**-w** or **--wally** Display Wally
**-dog** or **--dogbert** Display Dogbert
**-al** or **--alice** Display Alice
**-phb** or **--phb** Display Pointy haired Boss
**-as** or **--asok** Display Asok
**-nd** or **--not_de** To use 'WM' instead of 'DE'
**-o** or **--os=STR** OS name
**-k** or **--kernel=STR** Kernel version
**-d** or **--de=STR** Desktop environment name
**-sh** or **--shell=STR** Shell name
**-u** or **--uptime=STR** Uptime
**-p** or **--package=INT** Number of packages
**-v** or **--vnstat=STR** Use vnstat instead of kernel
**-f** or **--file** Display art from file
**-r** or **--random** Display Random Art
**-rd** or **--random-dir=STR** Directory for random ascii art
**-s** or **--say=STR** Say provided text instead of info
**-sf** or **--say-file=STR** Say text from a file instead of info
**-m** or **--margin=INT** Spaces on the left side of info
**-g** or **--gap=INT** Spaces between info and info_value (default 10)
**-l** or **--length=INT** Length of the board (default 13)
**-h** or **--help** Print this help message

## Available colors
black  red  green  yellow  blue  magenta  cyan
bright_black  bright_red  bright_green  bright_yellow
bright_blue   bright_magenta  bright_cyan random

## Randomization
For random color:
```bash
fm6000 -color "random"
```
or
```bash
fm6000 -c "random"
```

For random character:
```bash
fm6000 -random
```
or
```bash
fm6000 -r
```

For random ascii from a directory:
```bash
fm6000 --random-dir "directory_name"
```
or
```bash
fm6000 -rd "directory_name"
```

## Troubleshooting
If your distro is not {arch, debian, fedora, freeBSD, gentoo, venom, solus} based fetch-master-6000 wont be able to detect number of packages
In that case you have to specify number of packages yourself
For example:
On Solus (eopkg)
*Solus is already supported*
command to list all istalled packages is:
> eopkg list-installed is slow because its prints a lot of info, use `ls /var/lib/eopkg/package` instead
```bash
eopkg list-installed
```
to count packages pipe the list to wc -l

```bash
eopkg list-installed | wc -l
```

make it an alias to avoid typing it everytime

```bash
alias fm6000='fm6000 -p $(eopkg list-installed | wc -l)'
```
Similiarly for other distros

```bash
fm6000 -p $(pacman -Q | wc -l)
```

### Can't locate experimental.pm
fm6000 uses experimental module to do a smartmatch for WMs .This module is pre-installed on most of the distros, if for some reason its not present. Use your package manager to install `perl-experimental` module.
