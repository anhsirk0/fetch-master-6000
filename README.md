# Fetch-master 6000

## Simple fetching tool  
ASCII art of Dilbert is taken from the [Kakoune text editor](https://github.com/mawww/kakoune)  
ASCII art of Alice, PHB is taken from [Christopher Johnson's collection](https://asciiart.website/index.php?art=comics/dilbert)  
ASCII art of wolf is taken from [asciiart.eu](https://www.asciiart.eu/animals/wolves)  

### Screenshots
![all1.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/all1.png)
![al2l.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/all2.png)
![arts.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/arts.png)

### installation
Its just a perl script
download it make it executable and put somewhere in your $PATH

### via install script
```bash
curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/install.sh | bash
```

### manually
with wget
``` bash
wget https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/fm6000.pl -O fm6000
```
### or
with curl
``` bash
curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/fm6000.pl --output fm6000
```
making it executable
```bash
chmod +x fm6000
```
copying it to $PATH (in this case /usr/local/bin/ (requires root), this step is optional)
```bash
# cp fm6000 /usr/local/bin/
```

### usage
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

### Displaying custom ASCII from file
```bash
fm6000 -f wolf.txt
```
![wolf.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/wolf.png)
```bash
kak wolf.txt
```
![rawwolf.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/rawwolf.png)

#### about custom ascii_art file
every line should be of same length (use spaces if needed)  
atleast 10 lines is required (use empty spaces lines if needed)

### Colors
![color1.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/color1.png)

![color2.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/color2.png)

### Geometry
![geometry.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/geometry.png)


### Available Options
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

### Available colors
black  red  green  yellow  blue  magenta  cyan  white random  

bright_black  bright_red      bright_green  bright_yellow  
bright_blue   bright_magenta  bright_cyan   bright_white  

### Randomization
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

### Troubleshooting
If your distro is not {arch, debian, fedora, freeBSD} based fetch-master-6000 wont be able to detect number of packages
In that case you have to specify number of packages yourself
For example:
On Solus (eopkg)
command to list all istalled packages is:
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
output
![out2.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/out2.png)

