![piCube](/doc/piCube.png)

Raspberry Pi Software for the SuperTech-IT 8x8x8 RGB LED Cube

## Quick Start 

### Install the custom Raspian image

Download the [modified Raspbian image](http://picube.uk/files/picube-raspian-20161021.img.gz) and write it to an SD card.

> (The [INSTALLATION](INSTALLATION.md) file contains instructions for building this image by hand if you prefer)

### Update the picube software to the latest version

Once booted, log in as the pi user (the password is 'raspberry') and update
the piCube software:

```console
pi@picube:~ $ cd picube
pi@picube:~/picube$ git pull
pi@picube:~/picube$ make distclean install
```

### Connect the cube to the Pi

![Pinout](/doc/GPIO.png)

### Run the included `paneltest` program

```console
pi@picube:~/picube$ cube examples/paneltest 5
```
> In this example, panel 5 is tested.

## Start the interactive shell and play

```console
pi@picube:~$ cube
Welcome to cube shell (Jim 0.77).
. cube.colour violet
. cube.fill
. cube.clear
. cube.text -twosides Hello
. cube.anim cosine 20
. help
. help cube.colour
. loop p 0 8 { cube.clear; cube.panel $p; delay 500 }
```

The shell is an embedded
[Jim Tcl](http://jim.tcl.tk/fossil/doc/trunk/Tcl_shipped.html) interpreter
which can be used to write programs to control the cube. There are also a
number of built-in animations which have been ported from 
[Doug Domke's Cube Application Template](http://d2-webdesign.com/cube)

### Run some example animation scripts

```console
pi@picube:~/picube$ cube examples/rain
pi@picube:~/picube$ cube examples/cyclone
pi@picube:~/picube$ cube examples/grower
```

This is the Super Big Show from 
[Doug Domke's Cube Application Template](http://d2-webdesign.com/cube)

```console
pi@picube:~/picube$ cube examples/Super_Big_Show
```

