---
layout: post
author: tyson
title: "Timers and interrupts: Following a monochrome PAL frame"
tags: experiment microcontroller electronics analog timer interrupt

series_title: Capturing composite video with a microcontroller
---

## Counting sync pulses
There are only three reasons the video signal can go to `0 volts`, all of which are related to syncing: a horizontal sync pulse, a (pre/post) equalising pulse, or a long-sync pulse. The type of sync pulse is determined by its duration:

|Sync pulse type |Duration|
|----------------|--------|
|H-sync          |`4.7 µs`|
|Equalising pulse|`2 µs`  |
|Long-sync pulse |`30 µs` |

An H-sync pulse marks the beginning of a new scanline, and the equalising/long-sync pulses are used to indicate frame transition. Let's try and use the TM4C123GH6PM's timers to count these sync pulses. The more complex logic needed to retrieve an image from the signal can then be built upon this foundation.
