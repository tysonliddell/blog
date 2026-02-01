---
layout: post
author: tyson
title: "Analog to digital: Sampling an active video signal"
tags: experiment microcontroller electronics analog ADC

series_title: Capturing composite video with a microcontroller
---
{% capture part2-url %}{%post_url 2023-05-28-composite-video-experiment-part-2 %}{%endcapture%}

With the MCU now able to understand PAL video timing, the ADC can be configured
to capture the active video of the scanlines. It is this part of the signal
that contains the picture information, a monochrome image. These scanlines are
grouped into fields using the equalising and long-sync pulses described in [a
previous post][p2] and a full PAL image frame is
made up of two interlaced fields.

## Sampling with the ADC
For each scanline, an interrupt routine enables the ADC at the appropriate time
and continuously moves samples from the ADC FIFO into a storage array. Sampling
continues for the length of a scanline's active video signal and then stops
until the next scanline. The ADC has a maximum sample rate of 500 ksps and the
processor is running at 80 MHz. The interrupt code is simple enough that the
FIFO should never overflow under these conditions.

### Going 8-bit
Storage space is something to be careful of here. Capturing 1000 scanlines at
30 samples per scanline requires 30000 samples to be stored in SRAM. Storing
these as 32-bit or 16-bit integers would require 120,000 or 60,000 bytes of
storage, respectively. However, the SRAM only has a 32 KB byte capacity. The
solution is to truncate the 12-bit samples to 8-bit and store them as 8-bit
(unsigned) integers. This will allow for 256 shades of grey, provided the
samples are normalised appropriately.

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='5013a92d67e200b026ef54e5edadd53f289c94ff' %}

### Normalising the samples
The ADC produces 12-bit samples in the range 0 V to 3.3 V, while the monochrome
PAL signal uses values in the range 0.3 V (full black) to 1.0 V (full white) to
represent luminance. To make full use of the 8-bits of data that will be
stored, the values 0.3 V and 1.0 V should map to 0x00 and 0xFF in storage,
respectively. This can be achieved by applying the 12-bit -> 12-bit affine
transformation

```
sample -> (sample - SAMPLE_300mV) * (SAMPLE_3300mV / SAMPLE_700mV) = (sample - SAMPLE_300mV) * (0xFFF / SAMPLE_700mV),
```

which maps SAMPLE_300mV -> 0x000 and SAMPLE_1000mV -> 0xFFF, from which we can
then truncate the 4 least significant bits.

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='08ca800cf3e6f4378e76d5be6f719c04e036b8ec' %}

## UART data corruption
The implementation so far allow samples to be obtained from the ADC and printed
to the UART. Unfortunately, due to the high volume of data, UART data
corruption was observed:

```
..., 136, 136, 135, 135, 13136, 136, 136, ...
```

Note the value 13136 above, which is not a valid 8-bit integer. A reliable
communication protocol needs to be implemented on top of the UART to deal with
this.

[p2]: 2023-05-28-composite-video-experiment-part-2.html
