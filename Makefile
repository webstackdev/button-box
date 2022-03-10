#
# Customize to fit your environement
#
ARDUINO_HOME=/home/def/Downloads/arduino-1.0.3/
SERIAL=/dev/ttyACM0

# binutils
PREFIX=avr-
CC=$(PREFIX)gcc
CPP=$(PREFIX)g++
AR=$(PREFIX)ar
OBJCOPY=$(PREFIX)objcopy
SIZE=$(PREFIX)size

#
# Files to compile
#
C_FILES := $(wildcard $(ARDUINO_HOME)/hardware/arduino/cores/arduino/*.c)
C_OBJS = $(patsubst %.c,%.o,$(C_FILES))

CPP_FILES := $(wildcard $(ARDUINO_HOME)/hardware/arduino/cores/arduino/*.cpp)
CPP_FILES := $(filter-out $(ARDUINO_HOME)/hardware/arduino/cores/arduino/main.cpp, $(CPP_FILES))
CPP_OBJS = $(patsubst %.cpp,%.o,$(CPP_FILES))

#
# Compiler flags
#
LDFLAGS=-Wl,--gc-sections
OPT_FLAGS=-Os -g
CFLAGS=$(OPT_FLAGS) -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -MMD -DUSB_VID=null -DUSB_PID=null -DARDUINO=103 -I$(ARDUINO_HOME)/hardware/arduino/cores/arduino -I $(ARDUINO_HOME)/hardware/arduino/variants/standard
CPPFLAGS=-fno-exceptions $(CFLAGS)

#
# Targets
#
all: main

$(C_OBJS): %.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

$(CPP_OBJS): %.o: %.cpp
	$(CPP) -c $(CPPFLAGS) $< -o $@

libcore.a: $(C_OBJS) $(CPP_OBJS)
	for o in $(C_OBJS) $(CPP_OBJS); do \
		$(AR) rcs $@ $$o; \
	done

main.elf: main.cpp libcore.a
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $< libcore.a

main: main.elf
	$(OBJCOPY) -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 $< $@
	$(OBJCOPY) -O ihex -R .eeprom $< $@
	$(SIZE) $@

.PHONY: push
push: main
	avrdude -C$(ARDUINO_HOME)/hardware/tools/avrdude.conf -patmega328p -carduino -P $(SERIAL) -b 115200 -D -Uflash:w:main:i

.PHONY: clean
clean:
	rm -f $(CPP_OBJS)
	rm -f $(C_OBJS)
	rm -f main.elf
	rm -f main
