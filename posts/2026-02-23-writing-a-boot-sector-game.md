```text
author: Tyson Liddell
tags: 8088 IBM-PC
```
# Writing a boot sector game
I recently completed writing a boot sector game in 8088 assembly language
targeting the 5150 IBM PC. It's less than 512 bytes in size, runs without the
operating system and explores a significant slice of the hardware-software
interface of the IBM PC.

<img src="../assets/images/boot-sector-snake-pcjs.png" alt="in-game image" width="500"/>

See the detailed [technical write up][snake-repo] in the git repository for a
detailed outline of lessons learned and some neat tricks to make this work.
Highlights include:

- Used BIOS interrupts for keyboard, system-timer and video initialisation.
- Worked with memory-mapped IO to drive the display.
- Used VRAM as a storage area by hiding data in character attributes, leaving a
  tiny memory footprint. This game can run on the most memory constrained
  systems.
- Iterfaced directly (without using the BIOS) with several hardware systems
  including the PIT, PPI and PC speaker. Used bit banging to drive the speaker
  with the CPU (because why not?).
- Navigated BIOS source code to determine further details about the power-on
  state of the system and hardware.
- Diagnosed and fixed tricky, non-deterministic hardware faults including PC
  speaker and PIT contention on the PPI, all without access to debugging tools.
- Worked around innaccurate emulation/hardware by implementing a pseudorandom
  number generator, improving the code and portability in the process.

[snake-repo]: https://github.com/tysonliddell/boot-sector-snake
