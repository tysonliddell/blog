```text
author: Tyson Liddell
tags: 8088 IBM-PC
```
# Operating in MDA mode with a VGA card
Recently acquired an [Olivetti PCS86][pcs86-info] (an XT clone) and wanted to
run my recently written [snake boot sector game][boot-sector-game-post] on it.
Since the PCS86 uses an (onboard) Paradise PVGA1A-JK VGA card and the game was
written for a monochrome MDA card, some changes were needed to get it to work.
The simplest change is to add a couple of instructions to switch to video mode
`07h` like so:

```
mov ax,0x0007
int 0x10
```

This change is supposed to configure the graphics card to operate in monochrome
mode and read text mode video data from segment 0xB000. This did not work for
me. I found that the VGA card was still reading data from the color text area
0xB800, even after being instructed to move to mode 7 where data is supposed to
be read from 0xB000. It seems that the BIOS was trying to "help" and upon
recognising a VGA card was installed it translated the request for mode `07h`
to something else.  I found that I could get around this by manually overriding
some BIOS state (the equipment word list) to trick it into thinking it had
monochrome video:

```
; convince the BIOS that the primary display is a monochrome adaptor so that
; we can switch to mode 7 (monochrome 0xb000 region) correctly.
mov ax, 0x0040      ; Point to BIOS Data Area (BDA)
mov es, ax
mov ax, [es:0x0010] ; Get current equipment word
or  ax, 0x0030      ; Set bits 4-5 (80-column monochrome)
mov [es:0x0010], ax ; Update equipment word

mov ax,0x0007       ; switch to monochrome text video mode
int 0x10
```

With this change in place the game runs perfectly on the PCS86 with VGA card
even though all the game logic is MDA-based. The game also continues to work on
machines with MDA cards, although this was only tested in emulation (86Box).

## Why this works
Here's [some code][bios-int10-code], taken from an open source XT BIOS, that
shows what's going on when `int 0x10` is used to set the video mode:

```
INT_10: STI                                     ; Video bios service AH=(0-15.)
        CLD                                     ;  ...strings auto-increment
        PUSH    BP
        PUSH    ES
        PUSH    DS
        PUSH    SI
        PUSH    DI
        PUSH    DX
        PUSH    CX
        PUSH    BX
        PUSH    AX
        MOV     BX,40h
        MOV     DS,BX
        MOV     BL,DS:10h                       ; Get equipment byte
        AND     BL,00110000b                    ;  ...isolate video mode
        CMP     BL,00110000b                    ; Check for monochrome card
        MOV     BX,0B800h
        JNZ     C_01                            ; ...not there, BX --> CGA
        MOV     BX,0B000h
```

Note that the very first thing the interrupt does is set the memory segment for
video based on the value of the equipment word, which is why the hack above
works.

## Useful links
- https://mendelson.org/wpdos/videomodes.txt
- [Paradise PVGA1A data sheet](https://theretroweb.com/chip/documentation/wd-pvga1a-669d798d925a8636886868.pdf)
- https://jeffpar.github.io/kbarchive/kb/061/Q61806/
- https://github.com/virtualxt/pcxtbios/blob/54751cc0ee25cb53173262e4f37be5344de580d6/original/bios.asm

[boot-sector-game-post]: ./2026-02-23-writing-a-boot-sector-game.html
[bios-int10-code]: https://github.com/virtualxt/pcxtbios/blob/54751cc0ee25cb53173262e4f37be5344de580d6/original/bios.asm#L2023-L2041
[pcs86-info]: https://olivrea.de/olivetti-pcs-86/
