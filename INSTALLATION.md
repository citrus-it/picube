![piCube](/doc/piCube.png)

Raspberry Pi Software for the SuperTech-IT 8x8x8 RGB LED Cube

## Manual Installation

### Install Vanilla Raspbian on your Raspberry Pi

Download [Raspbian](https://www.raspberrypi.org/downloads/raspbian/)
and install it on your SD card. The minimal image is sufficient.

### (Optionally) update the distribution to the latest version

```console
pi@picube:~ $ sudo apt-get update
pi@picube:~ $ sudo apt-get dist-upgrade
pi@picube:~ $ sudo apt-get clean
pi@picube:~ $ sudo shutdown -r now
```

### Install the real-time linux kernel

This is optional but without this kernel the cube performance will suffer if
the CPU becomes heavily loaded.

A pre-compiled version of the Linux kernel with the
[RT Preempt](https://rt.wiki.kernel.org/index.php/Main_Page)
patch applied is available for all Raspberry Pi models at picube.uk and
can be installed as follows.

```console
pi@picube:~ $ wget http://picube.uk/files/raspberrypi-kernel-20161009.deb
pi@picube:~ $ sudo dpkg -i raspberrypi-kernel-20161009.deb
pi@picube:~ $ rm raspberrypi-kernel-20161009.deb
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
pi@picube:~ $ sudo shutdown -r now
```

### Install additional software

```console
pi@picube:~ $ sudo apt-get install git
```

### Clone this repository and build the software

```console
pi@picube:~ $ git clone https://github.com/hummypkg/picube.git
pi@picube:~ $ cd picube
pi@picube:~/picube $ make install
```

