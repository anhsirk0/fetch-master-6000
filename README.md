# Fetch-master 6000

## Simple fecthing tool  
ASCII art for dilbert is taken from the Kakoune text editor

### Screenshots
![fm6000.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/fm6000.png)

### installation
Its just a perl script
download it make it executable and put in your path folder

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
bash fm6000
```

## Options
if for some reason fm6000 is unable to detect packages or any other options,  
you can specify these options through commandline args  
### For example

```bash
fm6000 -o Manjaro -p 1729 -s zsh
```
output

![out1.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/out1.png)

```bash
fm6000 -p $(pacman -Q | wc -l)
```
output
![out2.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/out2.png)

### Colors
![color1.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/color1.png)

![color2.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/color2.png)

### Geomtry
![geometry.png](https://github.com/anhsirk0/fetch-master-6000/blob/master/screenshots/geometry.png)


### Available Options
**-h** or **--help** for help  
**-c** or **--color** for base color  

**-o** or **--os** for os  
**-k** or **--kernel** for kernel  
**-d** or **--de** for desktop environment  
**-s** or **--shell** for shell  
**-u** or **--uptime** for uptime  
**-p** or **--package** for package count  

**-m** or **--margin** Space on the left side of info   
**-g** or **--gap** Spaces between info and info_value  
**-w** or **--width** Width of the board (should be greater than 14)  

### Available colors
black  red  green  yellow  blue  magenta  cyan  white  

bright_black  bright_red      bright_green  bright_yellow  
bright_blue   bright_magenta  bright_cyan   bright_white  
