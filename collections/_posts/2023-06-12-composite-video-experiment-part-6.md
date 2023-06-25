---
layout: post
author: tyson
title: "Speeding up UART data transfer: Capturing a monochrome video animation"

tags: UART XMODEM

series_title: Capturing composite video with a microcontroller
---

The baud rate of the UART on the TM4C123GH6PM was maxed out to `1500000` to send image data from the microcontroller to a laptop as quickly as possible. Any value higher than this caused a breakdown in communication due to broken frames that XMODEM/CRC could not recover from. I suspect that this is because the ICDI that connects the Tiva C to the laptop uses low-speed USB, which is limited to 1.5 Mbps. A Python script was added to continuously slurp the image data from the UART and render each PAL field to the screen in real time, resulting in the following scene from Guy Ritchie's Lock, Stock & Two Smoking Barrels.

![first-animation][first-animation]

The result is crude, but it works! In fact, the image quality turned out better than I expected.

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='4597cdeeaae2310ed60729ee5be8e56058eb0406' %}

## Where to from here
The initial goal of this project has been reached: obtain picture data from a composite video signal using a microcontroller. Here are some further areas to explore in the future:
- The UART data transfer is the bottleneck in the animation creation process:
    - Image compression could be performed on the MCU before sending the data over UART.
    - USB could be used, instead of UART, for faster data transfer (up to 12 Mbps on full speed). This would allow sending 1 byte per µs, which should be able to keep up with the scanline in real time.
- Audio data could be captured too. Timing the second ADC so that it takes a single audio sample between scanlines would give `~ 300 scanlines * 50 fields per second = 15 ksps`.
- The monochrome signal uses 0.3 volts for black and 1.0 volts for white, meaning that mid-grey is 0.65 volts. Apparently the RPi 4 can sample digital IO at 10 MHz. A circuit could be setup so that the GPIO pins will go high when the value of the signal is > 0.65 volts and low when < 0.65 volts. If some noise is added to the input signal, dithering can be applied to get a reasonable image.
- The ADC managed to take over 50 samples per scanline, but, at the limit of `500 ksps` for a simgle ADC, this shouldn't be possible. The sampling duration is only around `56 µs`, so we shouldn't be getting more than around 28 samples. Is the ADC actually sampling at `1 Mbps`?

[first-animation]: {{ '/assets/images/composite-video/first_animation.gif' | relative_url }}
