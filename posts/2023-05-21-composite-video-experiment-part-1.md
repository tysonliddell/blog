```text
author: Tyson Liddell
tags: capturing-composite-video-with-a-microcontroller
```
# Making a composite video signal monochrome
Let's see how much of a composite video signal, in this case from an old DVD
player, can be retrieved using a Tiva C Launchpad (TM4C123GH6PM). This MCU is
not a great choice for sampling such a signal: its ADC will not be able to keep
up with the speed at which a CRT sweeps a scanline. However, a low resolution
image might be possible if the signal is sampled as fast as possible.

## The monochrome PAL signal
Each scanline in a monochrome PAL video signal is made up of several sections:
- A (low) horizontal sync pulse
- The *back porch*
- The *active video*
- The *front porch*

The active video section lasts around 52 microseconds and contains the
luminance information for the scanline displayed. Its voltage controls the
brightness of the CRT beam in real time as each scanline is drawn, which makes
composite video an analog process. The ADC of the TM4C123GH6PM has a max sample
rate of 500 ksps, allowing 500000 * 52 * 10^(-6) = 26 samples per displayed
scanline to be captured. This should provide enough data for a very low
resolution image.

## Colour in a PAL signal
Colour is added to the legacy monochrome PAL signal with a high-frequency *QAM
(Quadrature Amplitude Modulation)* subcarrier. This subcarrier contains only
chrominance information, is added to the active video portion of the scanline,
and must be used in conjunction with the baseband luminance signal to form a
color image. A *colourburst* is added to the flat back porch of the legacy
signal: this contains the QAM carrier reference phase necessary to demodulate
the subcarrier signal.

The frequency of the chrominance subcarrier was determined by inspecting the
colourburst with an oscilloscope. 4.43 MHz was observed, which is expected for
a PAL signal. This is a problem for the microcontroller, because its ADC cannot
sample this frequency fast enough. A passive RC low-pass filter was used to
remove the chrominance subcarrier, while keeping the luminance signal intact. A
100 pF capacitor and 4.7 kOhm resistor results a cutoff frequency Fc of

```
Fc = 1/(2*pi*R*C) = 1/(2*pi*(100*10^(-12))*(4700)) ~ 340 kHz.
```

The chrominance subcarrier is clearly visible in the colourburst and active
video sections of the unfiltered signal:

![colourburst-unfiltered][colourburst-unfiltered]
![two-unfiltered][two-unfiltered]
![four-unfiltered][four-unfiltered]

The low-pass filter appears to clean this up nicely:

![colourburst-filtered][colourburst-filtered]
![two-filtered][two-filtered]
![four-filtered][four-filtered]

Hopefully, this filtered output provide a clear enough luminance signal to be
read by the ADC of the MCU, and a black-and-white image can be retrieved.

# Useful links
- https://www.batsocks.co.uk/readme/video_timing.htm
- https://en.wikipedia.org/wiki/PAL
- https://en.wikipedia.org/wiki/Composite_video
- https://en.wikipedia.org/wiki/Quadrature_amplitude_modulation

[colourburst-filtered]: ../assets/images/cv-experiment-colourburst_filtered.png
[colourburst-unfiltered]: ../assets/images/cv-experiment-colourburst_unfiltered.png
[four-filtered]: ../assets/images/cv-experiment-four_scanlines_filtered.png
[four-unfiltered]: ../assets/images/cv-experiment-four_scanlines_unfiltered.png
[two-filtered]: ../assets/images/cv-experiment-two_scanlines_filtered.png
[two-unfiltered]: ../assets/images/cv-experiment-two_scanlines_unfiltered.png
