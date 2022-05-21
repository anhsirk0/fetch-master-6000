# Fetch-master 6000

## Simple fetching tool
### Works on Linux & BSD

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
### install script options
- to define install location set "install_path" variable(this variable defaults to $HOME/.local/bin)
- to define whether to use root or not set "root" variable(its value must be 1 or 0)(this variable defaults to 0 since $HOME/.local/bin is a user directory)
### example
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
fm6000 -f wolf.txt
```
![wolf.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/wolf.png)
```bash
kak wolf.txt
```
![rawwolf.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/rawwolf.png)

```bash
fm6000 -f astronaut.txt -c cyan
```
![astronaut.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/astronaut.png)

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
**-h** or **--help** for help
**-c** or **--color** for base color
**-w** or **--wally** display Wally
**-dog** or **--dogbert** display Dogbert
**-al** or **--alice** display Alice
**-phb** or **--phb** display Pointy Haired Boss
**-as** or **--asok** display Asok
**-r** or **--random** display Random art
**-f** or **--file** display ascii art from file

**-o** or **--os** for os
**-k** or **--kernel** for kernel
**-de** or **--de** for desktop environment
**-s** or **--shell** for shell
**-u** or **--uptime** for uptime
**-pa** or **--package** for package count
**-n** or **--not_de** to use 'WM' instead of 'DE'
**-v** or **--vnstat** to use vnstat instead of kernel

**-m** or **--margin** Space on the left side of info
**-g** or **--gap** Spaces between info and info_value
**-l** or **--length** Length of the board (should be greater than 14)

> option can be of single character or more
> for ex: -help can be used via -h -he -hel -help as long as it avoids ambiguity
> for ex: -d is ambiguous (-dogbert , -de) so atleast 2 characters should be specified

## Available colors
black  red  green  yellow  blue  magenta  cyan  white random

bright_black  bright_red      bright_green  bright_yellow
bright_blue   bright_magenta  bright_cyan   bright_white

## Randomization
For random color use:
```bash
fm6000 -color random
```
or
```bash
fm6000 -c random
```

For random character use:
```bash
fm6000 -random
```
or
```bash
fm6000 -r
```

For random ascii from a directory use:
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
*Solus is already supported*
For example:
On Solus (eopkg)
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
