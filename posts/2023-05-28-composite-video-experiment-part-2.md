---
layout: post
author: tyson
title: "Timers and interrupts: Counting sync pulses"
tags: experiment microcontroller electronics analog timer interrupt comparator

series_title: Capturing composite video with a microcontroller
---

There are only three reasons a PAL video signal can go to 0 volts in normal
operation, all of which are related to syncing: a horizontal sync pulse, a
(pre/post) equalising pulse, or a long-sync pulse. The type of sync pulse is
determined by its duration:

|Sync pulse type |Duration        |
|----------------|----------------|
|H-sync          |4.7 microseconds|
|Equalising pulse|2   microseconds|
|Long-sync pulse |27  microseconds|

An H-sync pulse marks the beginning of a new scanline, and the
equalising/long-sync pulses are used to indicate field transition. The
TM4C123GH6PM's timers are used to count and classify these sync pulses as they
occur. The more complex logic needed to retrieve an image from the signal will
be built upon this foundation.

## Timers
### The General Purpose Timer Module (GPTM)
The length of each sync pulse can be measured using the General Purpose Timer
Module (GPTM) of the TM4C123GH6PM. The GPTM consists of six timer blocks, and
each block contains two independent 16-bit timers: TIMERA and TIMERB, which can
be concatenated to form a single 32-bit timer. The GPTM hardware is independent
of the Cortex-M4F processor and keeps count of system clock pulses.  The value
of the count is made available in a GPTM register.

### Timer value wrap
The value of the 32-bit timer register increments by one on each clock pulse
(tick) and wraps around to 0 after 0xFFFFFFFF. The difference between any two
such values gives the number of ticks that occurred between their occurrences.
This can be used to compute T_us, the amount of time passed in microseconds,
with the formula

```
T_us = number_of_clock_pulses * clock_period_us = number_of_clock_pulses * (1/clock_frequency_hz) * 1000000.
```

The C standard guarantees that if the timer wraps between taking the first and
second measurement the difference will still be correct, so long as no more
than 0xFFFFFFFF ticks occurred: an unsigned uint32_t obeys the laws of
arithmetic modulo 2^32. This allows for a maximum interval of 4294967295 ticks
to be measured. This is about 53 seconds if the processor is running at its
maximum rated speed of 80 MHz. Since the video signal operates at the
microsecond level, this is plenty of breathing space.

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='f5acd03aa3b6a4b899fb1c05c3ab5c9349289551' %}

## Increasing the clock speed
The shortest PAL sync pulse is 2 microseconds in length, while the default
processor clock speed of the TM4C123GH6PM is 16 MHz. It makes sense to increase
the processor clock speed to the maximum possible value of 80 MHz. This will
increase the number of clock cycles per microsecond from 16 to 80, allowing
more instructions to be executed during this short 2 microsecond window. This
is achieved by enabling the phase-locked loop (PLL) on the microcontroller. The
PLL multiplies the clock signal, provided by a 16 MHz external crystal, to a
value configured in the Run-Mode Clock Configuration registers (RCC/RCC2).
Internally the PLL produces a 400 MHz clock, but a maximum of 80 MHz is made
available to the processor, as this is its maximum rating.

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='060ed3fb8cf26a9839bdcf91c3c0ccb7561671be' %}

## Interrupts
To classify and count the PAL sync pulses that occur, there are two events in
the signal to intercept: voltage hits 0 volts and voltage leaves 0 volts.
These two events mark the beginning and end of each sync pulse, respectively.
This experiment utilised the microcontroller's analog comparator for this
purpose and development relied heavily on small incremental changes and lots
of testing.

### Testing the comparator
To confirm that the basic comparator set up was correct, the comparator was
polled every 500 ms and its output, 0 or 1, printed to the UART. A change in
the output value was observed when changing the voltage difference across the
c0+ and c0- pins, as expected.

### Adding an interrupt
An interrupt was added to the comparator to print a message when the condition
Vc0+ > Vc0- occurs. This resulted in a flood of UART messages whenever the
comparator pins were held in this state.

### Counting pulse duration
It was surprisingly easy to add the logic to count how long the comparator was
in the trigger state. The comparator's output can be inverted, and hence the
interrupt trigger reversed:

```c
void comparator_count_low_handler(void) {
    static uint32_t start_ticks;

    const uint32_t current_ticks = get_timer_value(TIMER0);
    const bool is_ac_inverted = get_bit(&AC->ACCTL0, 1);
    if (!is_ac_inverted) {
        start_ticks = current_ticks;
        printf("Comparator went low at tick %lu\r\n", start_ticks);
        set_bit(&AC->ACCTL0, 1); // invert comparator output
    } else {
        uint32_t ticks_elapsed = current_ticks - start_ticks;
        uint32_t millis_elapsed = ticks_to_microseconds(ticks_elapsed) / 1000;
        printf("Comparator was low for %lu ms\r\n", millis_elapsed);
        clear_bit(&AC->ACCTL0, 1); // uninvert comparator output
    }

    set_bit(&AC->ACMIS, 0); // clear the interrupt
}
```

The c0+ comparator pin was then configured to use an internal reference
voltage, which was set to the lowest non-zero setting of ~149 mV. This causes
the interrupt to start counting whenever the c0- pin is less than 149 mV and
stop counting when it goes above 149 mV. This is exactly what's needed to
measure the length of a sync pulse. Experimenting with multiple voltages
revealed that the interrupt was successful, as shown in the sample UART output:
```
Comparator went low at tick 751
Comparator was low for 2 ms
Comparator went low at tick 741359713
Comparator was low for 5269 ms
Comparator went low at tick 2526848965
Comparator was low for 12566 ms
Comparator went low at tick 3729933375
Comparator was low for 3151 ms
```

### Frying a comparator
During testing I fried the comparator after accidentally shorting a couple of
pins on the dev board. Bang! Following the sparks, no reading could be obtained
from the comparator. Luckily the other comparator in the module continued to
function correctly and it was used for the rest of the experiment. The lesson
here is to keep the microcontroller powered off when rewiring things.

### Enabling the FPU
The FPU was enabled to make the conversion of 12.5 ns tick counts into
(micro/milli)second values simpler and to prevent integer overflow.

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='7ef63f94be75f62a0874cf51554b4e0bb5198ae9' %}

### Don't forget to turn off the UART!
When first connecting the composite video to the comparator on the board, the
following result was obtained:

```
Comparator was low for 3248 us
Comparator was low for 3248 us
Comparator was low for 3248 us
Comparator was low for 3248 us
```

This was unexpected; PAL sync pulses are nowhere near this long! Experimenting
with a square wave signal generator, it was observed that the correct results
were obtained whenever the input signal was low for at least 3248 microseconds.
Any time the input signal was held low for less than this value, say 100
microseconds, the result would still say 3248 microseconds. The printf debug
messages in the interrupt were the cause. printf is a heavy function and the
UART was running at a baud rate of 115200. The simple fix was to store the
values in an array and print them all when finished taking measurements.

Some satisfying results were then observed :)
```
// Square wave (50% duty cycle) with period of 2ms
Comparator was low for 1000 us
Comparator was low for 1000 us
Comparator was low for 999 us
Comparator was low for 1000 us
```

```
// Square wave (50% duty cycle) with period of 10us
Comparator was low for 4 us
Comparator was low for 4 us
Comparator was low for 4 us
Comparator was low for 4 us
```

```
// Square wave (50% duty cycle) with period of 2us
Comparator was low for 1 us
Comparator was low for 2 us
Comparator was low for 2 us
Comparator was low for 2 us
```

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='1569e0336a531a8eafeb2829caa59c693ea9aa56' %}

## Measuring the sync pulses
Following a couple of small tweaks to the code, the sync pulses from the PAL
signal were observed. The 4 microsecond h-sync pulses, 2 microsecond equalising
pulses and 27 microseconds long sync pulses are all clearly visible:

```
Sync pulse lengths:
len: 2 us, time since last pulse: 29 us     // equalising pulse
len: 2 us, time since last pulse: 32 us     // equalising pulse
len: 2 us, time since last pulse: 31 us     // equalising pulse
len: 2 us, time since last pulse: 32 us     // equalising pulse
len: 2 us, time since last pulse: 31 us     // equalising pulse
len: 27 us, time since last pulse: 56 us    // start of field 1
len: 27 us, time since last pulse: 32 us    // start of field 1
len: 27 us, time since last pulse: 31 us    // start of field 1
len: 27 us, time since last pulse: 32 us    // start of field 1
len: 27 us, time since last pulse: 31 us    // start of field 1
len: 2 us, time since last pulse: 7 us      // equalising pulse
len: 2 us, time since last pulse: 32 us     // equalising pulse
len: 2 us, time since last pulse: 31 us     // equalising pulse
len: 2 us, time since last pulse: 32 us     // equalising pulse
len: 2 us, time since last pulse: 31 us     // equalising pulse
len: 4 us, time since last pulse: 34 us     // half scanline
len: 4 us, time since last pulse: 63 us     // scanline
len: 4 us, time since last pulse: 64 us     // scanline
len: 4 us, time since last pulse: 64 us     // scanline

// SNIP

len: 4 us, time since last pulse: 64 us     // scanline
len: 2 us, time since last pulse: 61 us     // equalising pulse
len: 2 us, time since last pulse: 31 us     // equalising pulse
len: 2 us, time since last pulse: 32 us     // equalising pulse
len: 2 us, time since last pulse: 31 us     // equalising pulse
len: 2 us, time since last pulse: 32 us     // equalising pulse
len: 27 us, time since last pulse: 56 us    // start of field 2
len: 27 us, time since last pulse: 31 us    // start of field 2
len: 27 us, time since last pulse: 32 us    // start of field 2
```

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='a50e09a93787d03e2a9d13034bb61d4b4e03114c' %}

## Useful links
- https://www.batsocks.co.uk/readme/video_timing.htm
- https://en.wikipedia.org/wiki/PAL
- https://en.wikipedia.org/wiki/Composite_video
