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
you can specify these options from command line
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

### Available Options
*-o* or *-os* for os  
*-o* or *-kernel* for kernel  
*-o* or *-wm* for wm  
*-o* or *-shell* for shell  
*-o* or *-uptime* for uptime  
*-o* or *-package* for package  
