# Fetch-master 6000

## Simple fetching tool  
ASCII art of dilbert is taken from the Kakoune text editor https://github.com/mawww/kakoune  
ASCII art of alice is taken from Christopher Johnson collection: https://asciiart.website/index.php?art=comics/dilbert     

### Screenshots
![all1.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/all1.png)
![al2l.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/all2.png)
![wally.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/wally.png)
![arts.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/arts.png)
![dogbert.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/dogbert.png)
![alice.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/alice.png)
![phb.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/phb.png)
![asok.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/asok.png)
![random.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/random.png)

### installation
Its just a perl script
download it make it executable and put somewhere in your $PATH

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

### usage
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
black  red  green  yellow  blue  magenta  cyan  white  

bright_black  bright_red      bright_green  bright_yellow  
bright_blue   bright_magenta  bright_cyan   bright_white  

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

