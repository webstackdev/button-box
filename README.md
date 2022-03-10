# Arduino Rotary Encoder Code for Button Boxes

![Sample button box](https://raw.githubusercontent.com/webstackdev/button-box/main/static/racing-sim-button-box-rotary-encoder.jpg?raw=true)

This project is to use an Arduino Uno R3 board to support rotary encoders in D-I-Y button boxes.
These boxes are popular in the racing, flight, and space sim communities because you can tailor
the box exactly to your needs and commercial variants are pricey. They're usually built using
a stock electronics box (available on Amazon or AliExpress) with a laser-cut graphite carbon top
(those can be ordered from a variety of suppliers) and custom-printed labels.

If you're just using buttons and toggle switches, you can build a simpler box using an arcade-
style USB button board (also available on Amazon or AliExpress). Rotary encoders have two outputs:
`outputA` and `outputB`. By detecting the phase shift as the knob is rotated, you can tell both
where the knob is at on the dial and which way it is being turned. That's what this project sets
up your micro-controller to do.

By default it maps `outputA` and `outputB` to Arduino pins `6` and `7` respectively. The Uno has
a total of fourteen I/O pins. If you have more rotary encoders (as in the above image), simply
adjust the code accordingly. You can either use an arcade board or add code to handle buttons/
toggle switches.

There are several software packages that allow you to map the controls in your button box to
whatever sim game you're interested in. Searching the sim forums on Reddit will give you an idea
of the strengths and weaknesses of different mappers, and what works with what game.

Happy simming!

## Overview

This has been tested using Arduino Uno R3 board and Arduino IDE v1.6.

## How to

To use this code with your Arduino Uno micro-controller:

1. Fetch the official Arduino IDE from arduino.cc:
   <http://arduino.cc/en/main/software>
   Untar the file to somewhere suitable (e.g. /home/user/arduino_ide)

2. Install the following packages

   `avr-libc avrdude binutils-avr gcc-avr`

You can also re-use the binaries shipped with the Arduino IDE. To do so, set your PATH environment variable accordingly.

3. Checkout this repository:
   git clone git://github.com/webstackdev/button-box.git

4. Edit the `Makefile` file to suit your environment. There are two variables that you will need to edit:

   - `ARDUINO_HOME`: the path where you untarred the IDE in step number one.
   - `SERIAL`: the path where your arduino listens on. If you don't know which one, try plugging and unplugging the board and see what pseudofile in `/dev/` is added.

5. Edit `main.c` file if needed.

6. `make` then `make push`.

## Notes

The Makefile supports three commands:
_ `all`: build and link the main binary
_ `push`: push the binary to the board \* `clean`: remove the intermediary files
