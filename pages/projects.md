
# Some projects
## Composite video decoder
One day I got the itch to use a spare microcontroller to try and decode an
analogue video signal. I hooked my scope up to my old DVD player, studied the
PAL video timing spec and grokked that the 1 MHz sample rate of the on-board
DAC should *just* be fast enough to get a low-res image. There were a few
speedbumps along the way including:

- dealing with a high-frequency chrominance subcarrier signal an order of
  magnitude higher than what the DSP on my ARM Cortex M dev board was capable
  of sampling (thanks [Nyquist][nyquist-theorem]),
- timing issues,
- blowing up one of the MCU's internal comparators,
- serial data corruption on the UART,
- and more.

But in the end these issues were solved and the result was [better than
expected][composite-video-decoded].

![PAL-scanline][scope-out]

For detailed information see the technical write-ups:
- [Part 1](posts/2023-05-21-composite-video-experiment-part-1.html)
- [Part 2](posts/2023-05-28-composite-video-experiment-part-2.html)
- [Part 3](posts/2023-06-02-composite-video-experiment-part-3.html)
- [Part 4](posts/2023-06-04-composite-video-experiment-part-4.html)
- [Part 5](posts/2023-06-11-composite-video-experiment-part-5.html)
- [Part 6](posts/2023-06-12-composite-video-experiment-part-6.html)

## Partying like it's 1981: Building an IBM PC booter game

**In progress...**

What can you do with a limit of 512 bytes on your binary, no operating system,
a 4.77Mhz 8086 CPU and 64 KB of RAM? More than you might think. This project
explores the almost-forgotten world of "PC Booters" - games that squeeze into
the tiny boot sector of a floppy disk and run instead of the operating system.

## CHIP-8 emulator
[Implementation of a CHIP-8 emulator in Rust][chip8-github]. Here's a [screen
capture][chip8-rom] of rock, paper, scissors ROM (made by
[SystemLogoff][systemlogoff]) running in the emulator.

## Ray tracing in Rust
[Ray tracer][ray-tracer-github] implemented in rust. Produces pretty pictures like
this:

<img src="assets/images/rust-ray-tracer-result.jpg" alt="result-of-ray-tracer" width="500"/>

## Building a CPU
**In progress...**

Using a Xilinx Pynq Z2 FPGA to implement the RISC-V RV32I CPU. Involves VHDL
and a deep dive into computer architecture and digital design.

[composite-video-decoded]: assets/images/cv-experiment-first_animation.gif
[scope-out]: assets/images/cv-experiment-colourburst_unfiltered.png
[nyquist-theorem]: https://en.wikipedia.org/wiki/Nyquist%E2%80%93Shannon_sampling_theorem
[chip8-github]: https://github.com/tysonliddell/chip8-emulator
[ray-tracer-github]: https://github.com/tysonliddell/ray-tracing-1
[ray-tracer-result]: assets/images/rust-ray-tracer-result.jpg
[chip8-rom]: assets/images/chip8-rom.gif
[systemlogoff]: https://systemlogoff.com/
