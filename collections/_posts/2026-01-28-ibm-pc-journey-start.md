---
layout: post
author: tyson
title: "Down the Rabbit Hole"

tags: 8088 IBM-PC

series_title: Fun with the x86 - Programming the IBM
---

## Background
I've gone down a deep rabbit hole recently as my low-level programming
interests have intensified. The current projects are in progress:
- FPGA development (currently reading _Digital Design and Architecture_, RISC-V
  edition) with the aim of implementing a RISC-V processor on a Pynq Z2 board.
- Reading _Crafting Interpreters_. Decided that I want to implement the first
  OO-designed interpreter in C++, so I'm reading some C++ material.
- Reading _Hacking: The Art of Exploitation_.

This is a lot to be doing in parallel as a hobby, but let's see what sticks.

## IBM PCs
Reading _Hacking: The Art of Exploitation_ led me to working with 32-bit x86
assembly language, but didn't explain x86 in much depth. When reading about x86
and x86-64 assembly, I was intrigued by the history. The legacy of the original
8086/8088 runs deep in the x86 ISA, which still supports the original 16-bit
instructions. I want to understand where x86 comes from, so I'm going to start
where it all began and program the 8088. This (simpler) CPU contains the
fundamental core of all x86 processors.

Here's my rough plan (subject to change) as I read _Programming Boot Sector
Games_ and use 86Box to emulate the older IBM PCs:

-------------------------------------------------------------------------------
1. Start with the original IBM PC (5150) running with MDA display (no pixels,
   no colour, just characters).

2. Switch from MDA to CGA graphics when the I need to start addressing
   individual pixels. I might also play around with the Hercules video card to
   get pixels on a monochrome monitor too, just like people did in the old
   days.

3. Move to the IBM XT when I need more processing power.

4. Move to the IBM AT when I need more processing power.

5. Go through the 268,386,486 when I need more processing power.
-------------------------------------------------------------------------------

## Current Status
I've run into a small issue when trying to use a 160K disk image with the
original IBM PC (5150) running PC DOS 1.0, which did not occur when running
FreeDOS on an IBM XT (5160). I create a raw 160K floppy disk image using
`mtools` in Linux and put my binaries on it. When I load this disk into the
5150 and run `DIR` I get a bunch of trailing zeroes in the output like this:

TODO: ADD GIF

If I then format the disk from within the 5150 I lose the ability to mount it
in Linux, but the trailing zeroes go away and the disk functions as normal. I
have this same issue with the image file for the 160K disk containing PC DOS
1.0. It runs fine on the 5150, but I can't mount it in Linux.

## Next Task
My first mini-project is to build a tool that can manage the FAT 12 filesystem
in the same way that PC DOS 1.0 does, as it seems to be slightly different from
later versions of DOS like FreeDOS. It should allow me to create a new 160K raw
disk image and read/add/delete files to/from it from my Linux environment.

## Useful links
- WinWorld
  https://winworldpc.com/library/operating-systems#
- Bit savers
  bitsavers.org
- PCjs: The undocumented PC
  https://www.pcjs.org/software/pcx86/sw/books/undocumented_pc/
- DOS Days
  https://dosdays.co.uk/

## Books
- Programming Boot Sector Games: Toledo
- Programming the 8086/8088: Coffron
- Learn to Program with Assembly: Bartlett
