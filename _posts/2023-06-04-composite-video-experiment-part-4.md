---
layout: post
author: tyson
title: "Implementing a cyclic redundancy check (CRC)"
tags: mathematics CRC communication error-checking

series_title: Capturing composite video with a microcontroller
---

Data corruption is inevitable when sending bits along a wire. In the case of this project, sending the data collected for a single PAL field across UART, at a baud rate of 115200, reliably produces some data corruption. To implement a reliable communication protocol that can deal with this unreliable physical link, it's useful to know when data in the message has been unexpectedly changed. The cyclic redundancy check (CRC) is a robust way of achieving this.

## Simple methods to detect data corruption
Perhaps the simplest way to detect data corruption is with a parity bit appended to the data being sent. The bit is set to 1 if there are an odd number of set bits in the data and 0 otherwise. This is better than nothing, but isn't very reliable. If two bits flip, the parity bit will remain unchanged and the receiver won't know that data corruption occurred. 

A smarter approach is to take the sum of all bytes in the data being sent, modulo 256, and append the resultant byte to the payload. The original [XMODEM protocol](https://techheap.packetizer.com/communication/modems/xmodem.html) uses this checksum. Note that, since there are only 256 possible values for a byte, an arbitrary byte will be the correct checksum, on average, once in every 256 data payloads. In fact, `0x80 + 0x80 = 0x100 = 0x00 (mod 256)`, and thus it's possible to have undetected data corruption with only two flipped bits!

## The cyclic redundancy check (CRC)
The cyclic redundancy check is a much more effective method to detect data corruption. According the [Koopman](https://users.ece.cmu.edu/~koopman/crc/), an [appropriately chosen 32-bit CRC](https://users.ece.cmu.edu/~koopman/crc/c32/0x9960034c_len.txt) is guaranteed to detect 6 bit flips (Hamming distance of 6) in any message of length up to 32738 bits.

The CRC of a message `M` of length `L` bits is computed using polynomial long division over the field of integers mod 2:
1. Let `F` be the field of integers mod 2 and `g` the polynomial of degree `n` over `F` associated with the CRC being computed. CRC-32C, CRC-32K/6.4, CCITT-16, etc. each have a different polynomial. 
2. Write `M` as a string of bits and consider `M` as a representation of a polynomial of degree `L - 1` over `F`, the most significant bit corresponding to the highest power of the polynomial.
3. Compute the remainder `r` following the polynomial long division `(M * x^n ) / g` over `F`.
4. The coefficients of `r` give the resultant CRC 'checksum'.

A received (`message`, `crc`) pair can be checked for data corruption in two equivalent ways:
- The CRC algorithm can be computed on `message` and the result, `val`, compared against the value of `crc`. If `val != crc` then data corruption was detected.
- The CRC algorithm can be computed on the *codeword* (fancy name for the `message` and `crc` bits taken as a single contiguous value). Since addition and subtraction are equivalent over the field of integers mod 2, the codeword is equal to `M * x^n + r = M * x^n - r`, which is perfectly divisible by `g`. Therefore, if the result is non-zero, data corruption was detected.

### Common modifications
Consider the messages `11`, `011`, `0011`. When viewed as polynomials, they are equivalent: `x + 1 = 0x^2 + x + 1 = 0x^3 + 0x^2 + x + 1`. This means that they will each result in the same CRC value. To remedy this, it is common to flip the first `n` bits of the message before computing the CRC checksum.

When applying the CRC algorithm to the entire codeword, appending additional `0`s to a valid codeword results in another valid codeword: if `g` divides `h`, then `g` also divides `h * x`. To get around this, the checksum can be inverted before being appended to the message. This means that instead of checking that a received codeword is perfectly divisible by `g`, the receiver must check that the remainder is equal to a known value called the *residue*. The residue is uniquely determined by the polynomial `g` used.

### UART considerations
Since the Hamming distance guarantees provided by a CRC polynomial rely on the mathematics behind computing `M * x^n = r (mod g)` described above, the CRC implementation needs to account for the order the bits are sent along the wire. In particular, UART transmits data byte by byte, **least significant bit first**. This means that the 'in-flight' message bits are not the same as the contiguous bits in memory that make up the data. It's the in-flight bits that are susceptible to data corruption and need to be checksummed, and thus it is these bits that correspond to `M` above. Rather than making a copy of the message with each byte reversed and computing the CRC checksum on that, the bits of the CRC polynomial can be reversed, e.g. `110100 -> 001011` and corresponding modifications made to the typical (software) CRC implementation.

{% include github_commit.html repo='tysonliddell/bare-metal-tiva' sha='1e0f556e36fbdf0d9e8da30a780e979543c3e566' %}

## Useful links
- https://techheap.packetizer.com/communication/modems/xmodem.html
- https://www.cs.williams.edu/~tom/courses/336/outlines/lect7_2.html
- https://ceng2.ktu.edu.tr/~cevhers/ders_materyal/bil311_bilgisayar_mimarisi/supplementary_docs/crc_algorithms.pdf
- https://reveng.sourceforge.io/readme.htm
- https://users.ece.cmu.edu/~koopman/crc/
- https://users.ece.cmu.edu/~koopman/roses/dsn04/koopman04_crc_poly_embedded.pdf
