# SHC Shell Compiler

## Installation 

```
sudo apt install shc
```

## Example

```
shc -r -f scrip.sh
```

### Output

- sh.sh.x
- script.sh.x.c
- **script.sh.x**

Get the ```script.sh.x``` and distribute ! :).

## Man - an interface to the system reference manuals
```
    -e %s  Expiration date in dd/mm/yyyy format [none]
    -m %s  Message to display upon expiration ["Please contact your provider"]
    -f %s  File name of the script to compile
    -i %s  Inline option for the shell interpreter i.e: -e
    -x %s  eXec command, as a printf format i.e: exec('%s',@ARGV);
    -l %s  Last shell option i.e: --
    -o %s  output filename
    -r     Relax security. Make a redistributable binary
    -v     Verbose compilation
    -S     Switch ON setuid for root callable programs [OFF]
    -D     Switch ON debug exec calls [OFF]
    -U     Make binary untraceable [no]
    -H     Hardening : extra security protection [no]
           Require bourne shell (sh) and parameters are not supported
    -C     Display license and exit
    -A     Display abstract and exit
    -B     Compile for busybox
    -h     Display help and exit

    Environment variables used:
    Name    Default  Usage
    CC      cc       C compiler command
    CFLAGS  <none>   C compiler flags
    LDFLAGS <none>   Linker flags
```