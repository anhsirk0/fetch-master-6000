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


[33m              ╭─────────────────────────╮[0m
[33m    დოოოოოდ   │  [0m                       [33m│[0m
[33m    |     |   │  [0m[32mOS        [0mManjaro      [33m│[0m
[33m    |     |  ╭│  [0m[34mKERNEL    [0m5.11.9       [33m│[0m
[33m    |-ᱛ ᱛ-|  ││  [0m[33mWM        [0mawesome      [33m│[0m
[33m   Ͼ   ∪   Ͽ ││  [0m[32mSHELL     [0mzsh          [33m│[0m
[33m    |     |  ╯│  [0m[35mUPTIME    [0m4h, 39m      [33m│[0m
[33m   ˏ`-.ŏ.-´ˎ  │  [0m[34mPACKAGE   [0m1729         [33m│[0m
[33m       @      │  [0m                       [33m│[0m
[33m        @     ╰─────────────────────────╯[0m

