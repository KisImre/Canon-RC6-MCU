Canon-RC6-MCU
=============

This project implements the protocol of the Canon-RC6 infrared remote
controller on MCUs. The RC has a mode switch that can select instant or
delayed (2 seconds) shutter. The software samples a GPIO on the beginning and
decides the mode based on this GPIO's input state.

This is a standalone application. It sends the IR message and turns of the
microcontroller which is ideal for battery supplied applications. Before
starting transmitting the message the software waits 10ms which cames handy as
a power debounce.

Protocol
--------

The project is based on this
[article](http://www.pratikpanda.com/canon-rc6-remote-protocol/).

The protocol is quite simple. It stars and ends with a burst of 18 pulses and
the length of the delay between these two bursts selects the shutter mode.

The period of each pulse is 29.3us (34.1kHz) and the high time is 9.3us. The
instant shutter mode has a delay of 7.1ms and the delayed shutter mode operates
with 5.3ms gap between the bursts.

Build
-----

```
make PLATFORM=<stm32f4xx|lpc8xx> all
```

### Build targets

* all - Builds the project
* clean - Removes build directory
* deploy - Uploads the binary using OpenOCD
* debug - Uploads the binary using OpenOCD and goes into debug mode
* gdb - Starts gdb and connects to OpenOCD gdb server


Platforms
---------

The project handles multiple hardware platforms.

| Platform  | IR out | Mode select |
| --------- | ------ | ----------- |
| STM32F4xx | PD12   | PA0         |
| LPC8xx    | PIO0_0 | PIO0_4      |

Platform interface
------------------

* Startup/startup_[platform].S - MCU startup file
* platform_macros.h
    * `NANOSEC_TO_COUNTER(ns)` - Converts nanosecs to raw timer value
    * `Timer_IRQHandler` - Name of the timer interrupt handler function
* platform_[platform].c - Platform dependent function implementations
    * `init_gpio` - Initializes mode select and IR out GPIO
    * `init_timer` - Configures timer and sets the period 
    * `init_interrupt` - Enables timer interrupt
    * `is_instant_mode` - Return the mode select value
    * `set_active_count` - Sets the length of the high time of the timer output
    * `clear_timer_interrupt` - Clears timer interrupt
    * `power_down` - Powers down the MCU
* [platform].ld - Linker script
* openocd.cfg - OpenOCD configuration file

Possible improvements
---------------------

* GPIO configuration could come from a config header
