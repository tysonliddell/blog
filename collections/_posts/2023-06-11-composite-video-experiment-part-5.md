---
layout: post
author: tyson
title: "Communicating reliably over UART: Adding an error detecting communication protocol"

tags: CRC communication error-checking XMODEM protocol

series_title: Capturing composite video with a microcontroller
---
{% capture part3-url %}{%post_url 2023-06-02-composite-video-experiment-part-3 %}{%endcapture%}
{% capture part4-url %}{%post_url 2023-06-04-composite-video-experiment-part-4 %}{%endcapture%}

Microcontrollers like the TM4C123GH6PM include UART (universal asynchronous receiver-transmitter) hardware. Two devices connected via UART can establish a serial communication channel for sending data to each other. The communication is asynchronous because the two ends of the channel do not need to synchronise their clocks. Rather, each transmitted frame (of 5-9 bits) is bookended by a start bit and a stop bit that the receiver uses to sync itself up with the incoming data at the time of receipt.

Communication over a raw UART channel is not reliable, especially when prototyping on a breadboard, where electrical noise and poor connections are common. Indeed, data corruption was observed on the UART when [sampling the PAL active video signal]({{ part3-url | relative_url}}#uart-data-corruption). However, now that a [robust method]({{ part4-url | relative_url }}) for detecting data transmission errors has been implemented, a reliable communication protocol can be built.

## Creating a protocol
Initially, I came up with a simple protocol to allow the MCU to send packets to a receiver, where each packet would contain a complete scanline:

```c
/*
 * Send video field on UART with following simple, probably not robust,
 * protocol:
 *  - Tx a protocol packet (contains an entire scanline):
 *    +-----------------+--------------------+---------------+---------------+
 *    | scanline_number | num_scanline_bytes | scanline_data | CRC32 checksum|
 *    +-----------------+--------------------+---------------+---------------+
 *  - Wait for response from the recipient and then:
 *     - If ACK (0xFF) received, increase sequence number and send packet for
 *       next scanline
 *     - If response is anything other than `0xFF`, resend the same packet.
 */
```

The MCU would continually attempt to send each packet in sequence, advancing to the next only after receiving an ACK from the receiver.

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='c226b5036a3c67841fe1f5d052d76d8549090645' %}

In an effort to loosely couple the receiver to the data being transmitted, the protocol uses packets of variable size, but this is where things get dicey. If the value of `num_scanline_bytes` gets corrupted, the receiver will not be able to make sense of the packet. The protocol could be modified to use [byte stuffing](https://eli.thegreenplace.net/2009/08/12/framing-in-serial-communications/) or [COBS](https://en.wikipedia.org/wiki/Consistent_Overhead_Byte_Stuffing) to iron out this wrinkle; however, another problem arises with variable length packet sizes: a CRC checksum is only guaranteed to perform well if the packet size is capped. In the end, I settled on the XMODEM protocol. It's simple, elegant and can easily solve all of these problems.

## The XMODEM protocol
XMODEM is an iconic file transfer protocol that has been around since the 70s. Its simplicity allowed it to be widely adopted by BBSes across the world, and it has formed the foundation for a number of newer protocols. The protocol itself is specified in [this one-pager](https://techheap.packetizer.com/communication/modems/xmodem.html), which I won't repeat here. It's similar to my attempted protocol above, but with some important differences:
- Packets begin with a special byte value (`SOH`). This allows the receiver to identify the start of a packet and resync easily.
- The packet size is fixed, meaning that the receiver will always be able to determine the end of a received frame.

This project uses the [XMODEM/CRC](https://techheap.packetizer.com/communication/modems/xmodem-ymodem_reference.html) protocol, which replaces the naive checksum of the original spec with a 16-bit CRC. Unfortunately, the XMODEM/CRC protocol does not account for the fact that bits are sent least significant bit first on UART. As [mentioned earlier]({{ part4-url | relative_url }}#uart-considerations), this means that burst error detection will not be optimal. However, the protocol is still good enough for the purposes of this experiment.

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='7812d8f55a99e687c0aeef218ceacda2f3c287a1' %}
{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='094376a435302c29d2460d0f5f50de920f933bd9' %}

## Getting a PAL field from the MCU
With the reliable XMODEM/CRC protocol in place, application-level data corruption was eliminated! Minicom was configured to receive the data on the xmodem protocol with `lrx -c`, provided by [`lrzsz`](https://www.ohse.de/uwe/software/lrzsz.html). Using a script to convert the measurements to a `pgm` file, an image is successfully obtained from the signal:

![first-image][first-image]

This is an image from a scene in Men of Honour, starring Robert De Niro and Cuba Gooding Jr. 

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='b4941050c938c656b33e864ee92a2d765cc87132' %}

## Recap
Here is a quick recap of what went into obtaining the image above:
- The PAL composite video signal contains a high-frequency subcarrier that the ADC is unable to sample accurately. This subcarrier was removed with a rudimentary low-pass filter, consisting of a resistor and capacitor, resulting in a monochrome video signal.
- Timers and interrupts were set up on the microcontroller to follow the PAL video signal timing. The MCU's analog comparator triggers the interrupts, ensuring accurate measurement of pulses as short as `2µs` in length.
- The MCU's clock frequency was increased to `80 MHz`, using the PLL, allowing necessary instructions to be executed in the `2µs` window of the short sync pulse.
- Using the precise video signal timing information above, the built-in ADC sampled the active video portion of each scanline, resulting in a collection of luminance values. These 12-bit values were normalised and truncated to their most significant 8-bits, saving space in SRAM and ensuring that `0x00` corresponds to black and `0xFF` to white.
- A reliable communication protocol was implemented to deal with frequent UART data corruption, eliminating it entirely: XMODEM/CRC.

## Useful links
- https://eli.thegreenplace.net/2009/08/12/framing-in-serial-communications/
- https://techheap.packetizer.com/communication/modems/xmodem.html
- https://techheap.packetizer.com/communication/modems/xmodem-ymodem_reference.html
- https://www.youtube.com/watch?v=0HZqiFqp778
- https://en.wikipedia.org/wiki/XMODEM
- https://en.wikipedia.org/wiki/Consistent_Overhead_Byte_Stuffing
- https://www.embeddedrelated.com/showarticle/113.php
- https://conferences.sigcomm.org/sigcomm/1997/papers/p062.pdf

[first-image]: {{ '/assets/images/composite-video/first_image.jpeg' | relative_url }}
