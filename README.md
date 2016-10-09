![piCube](/doc/piCube.png)

Raspberry Pi Software for the SuperTech-IT 8x8x8 RGB LED Cube

## Quickest Installation

### Install the custom Raspian image

Download the [modified Raspbian image](http://picube.uk/files/picube-raspian-20161009.img.gz) and write it to an SD card.

### Update the picube software

Once booted, log in as the pi user (the password is 'raspberry') and update
the piCube software:

```console
pi$ cd picube
pi$ git pull
pi$ make clean install
```

## Quick Installation

### Install Vanilla Raspbian on your Raspberry Pi

Download [Raspbian](https://www.raspberrypi.org/downloads/raspbian/)
and install it on your SD card. The minimal image is sufficient.

### (Optionally) update the distribution to the latest version

```console
pi$ sudo apt-get update
pi$ sudo apt-get dist-upgrade
pi$ sudo apt-get clean
pi$ sudo shutdown -r now
```

### Install the real-time linux kernel

A pre-compiled version of the Linux kernel with the
[RT Preempt](https://rt.wiki.kernel.org/index.php/Main_Page)
patch applied is available for all Raspberry Pi models at picube.uk and
can be installed as follows.

```console
pi$ wget http://picube.uk/files/raspberrypi-kernel-20161009.deb
pi$ sudo dpkg -i raspberrypi-kernel-20161009.deb
pi$ rm raspberrypi-kernel-20161009.deb
```

(Alternatively you can build it yourself. There is a good write-up at
http://www.frank-durr.de/?p=203 )

### Disable SD card low-latency-mode (llm)

Add the following text to the end of the line in `/boot/cmdline.txt`

```
sdhci_bcm2708.enable_llm=0
```

### Allow the pi user to elevate scheduling priority and lock memory.

Add the following lines to `/etc/security/limits.conf`

```
pi	-	memlock		51200
pi	-	rtprio		99
```

### Reboot the Pi

```console
pi$ sudo shutdown -r now
```

### Install additional software

```console
pi$ sudo apt-get install git
```

### Clone this repository and build the software

```console
pi$ git clone https://github.com/hummypkg/picube.git
pi$ cd picube
pi$ make install
```

### Connect the cube to the Pi

![Pinout](/doc/GPIO.png)

### Run the included `paneltest` program

```console
pi$ cube examples/paneltest 5
```

## Start the interactive shell and play

```console
pi$ cube
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
pi$ cube examples/rain
pi$ cube examples/grower
```

This is the Super Big Show from 
[Doug Domke's Cube Application Template](http://d2-webdesign.com/cube)

```console
pi$ cube examples/Super_Big_Show
```

