# multizone-ada
MultiZone™ Security Trusted Execution Environment Ada Example

This repository, maintained by Hex Five Security, is a companion to the
[multizone-sdk](https://github.com/hex-five/multizone-sdk) repository, intended
to showcase Ada running on MultiZone.

This repo supports only the Hex Five X300 - RV32ACIMU Core for Xilinx Arty
A7-35T FPGA whereas MultiZone Security SDK supports the following cores /
boards:
 - Hex Five X300 - RV32ACIMU Core for Xilinx Arty A7-35T FPGA
 - Andes  N25 - RV32ACIMU Core for GOWIN GW2A-55K FPGA
 - SiFive E31 - RV32ACIMU Core for Xilinx Arty A7-35T FPGA
 - SiFive E51 - RV64ACIMU Core for Xilinx Arty A7-35T FPGA
 - SiFive S51 - RV64ACIMU Core for Xilinx Arty A7-35T FPGA

For Questions or feedback - send email to info 'at' hex-five.com.

### Installation ###

Upload the bitstream to the Arty board following directions from SiFive - https://sifive.cdn.prismic.io/sifive%2Fed96de35-065f-474c-a432-9f6a364af9c8_sifive-e310-arty-gettingstarted-v1.0.6.pdf

Install the GNAT Community Edition for RISC-V ELF from https://www.adacore.com/download.

Install the certified RISC-V toolchain for Linux - directions specific to a fresh Ubuntu 18.04 LTS, other Linux distros generally a subset
 ```
 sudo apt update
 sudo apt upgrade -y
 sudo apt install git make default-jre libftdi1-dev
 sudo ln -s /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/x86_64-linux-gnu/libmpfr.so.4
 wget https://github.com/hex-five/multizone-sdk/releases/download/v0.1.0/riscv-gnu-toolchain-20181226.tar.xz
 tar -xvf riscv-gnu-toolchain-20181226.tar.xz
 wget https://github.com/hex-five/multizone-sdk/releases/download/v0.1.0/riscv-openocd-20181226.tar.xz
 tar -xvf riscv-openocd-20181226.tar.xz
 git clone https://github.com/hex-five/multizone-ada
 sudo apt-get install libusb-0.1-4
 sudo apt-get install screen
```

If you have not already done so, you need to edit or create a file to place the USB devices until plugdev group so you can access them without root privileges:
```
sudo vi /etc/udev/rules.d/99-openocd.rules
```
Then place the following text in that file if it is not already there
```
# These are for the HiFive1 Board
SUBSYSTEM=="usb", ATTR{idVendor}=="0403",
ATTR{idProduct}=="6010", MODE="664", GROUP="plugdev"
SUBSYSTEM=="tty", ATTRS{idVendor}=="0403",
ATTRS{idProduct}=="6010", MODE="664", GROUP="plugdev"
# These are for the Olimex Debugger for use with E310 Arty Dev Kit
SUBSYSTEM=="usb", ATTR{idVendor}=="15ba",
ATTR{idProduct}=="002a", MODE="664", GROUP="plugdev"
SUBSYSTEM=="tty", ATTRS{idVendor}=="15ba",
ATTRS{idProduct}=="002a", MODE="664", GROUP="plugdev"
```
Detach and re-attach the USB devices for these changes to take effect.

Add environment variables and a path to allow the Makefiles to find the toolchain

edit ~/.bashrc and ~/.profile and place the following text at the bottom of both files.

Add environment variables and a path to allow the build script to find the
toolchain. For example, edit ~/.bashrc and ~/.profile and place the following
text at the bottom of both files:
```
export GNAT=/home/<username>/GNAT/2018-riscv32-elf
export RISCV=/home/<username>/riscv-gnu-toolchain-20181226
export OPENOCD=/home/<username>/riscv-openocd-20181226
export PATH="$PATH:/home/<username>/riscv-gnu-toolchain-20181226/bin"
```
Close and restart the terminal session for these changes to take effect.

### Compile and Upload the Project to the Arty Board ###

```
cd multizone-ada/
make clean
make
```

This will result in a HEX file that is now ready to upload to the Arty board.

```
make load
```

### Operate the Demo ###

The system contains three zones:
 - Zone 1: UART Console (115200 baud, 8N1) with commands that enable the following:
   - load, store exec - issue discrete load / store / exec commands to test the boundaries of physical memory protection in Zone 1
     - invalid commands generate hardware exceptions that send a response to the user via handlers that are registered in main.c
   - send / recv messages to / from other zones
   - timer - set a soft timer in ms 
   - yield - measure the round trip time through three zones when you yield context
   - stats - complete a number of yield commands and calculate statistics on performance
   - restart - restart the console
 - Zone 2: LED PWM + Interrupts
   - This Zone is running a modified version of SiFive's coreplexip_welcome demo with trap and emulate functions
   - Buttons 0-2 are mapped to interrupts in this Zone, they will cause the LED to change color for 5s and send a message to zone 1
   - These interrupt handlers themselves can be interrupted and resumed by pressing another button before the first handler is complete
 - Zone 3: Robot Control
   - This zone controls a robot via GPIO; if you do not have the robot then this zone simply yields for you
   - Robot commands are all issued ia messages from zone 1:
     - send 3 > - unfold
     - send 3 1 - begin recursive dance
     - send 3 0 - stop recursive dance when it reaches home
     - send 3 < - fold
 
### For More Information ###

See the MultiZone Manual (Pending) or visit [http://www.hex-five.com](https://www.hex-five.com)
