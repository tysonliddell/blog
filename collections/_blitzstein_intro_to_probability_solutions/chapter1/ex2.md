---
layout: post
author: tyson
title: "Exercise 1.9.2"
is_exercise: true
chapter: 1

usemathjax: true
hide_tags: true
---

**Exercise 1.9.2 (a)** How many 7-digit phone numbers are possible, assuming
that the first digit can't be a 0 or 1?

*Solution*:
There are 8 choices for the first digit followed by 10 for every other digit.
Therefore there are $$8 \cdot 10^6 = 8\,000\,000$$ possibilities.

**Exercise 1.9.2 (b)** Re-solve (b), except now assume also that the phone
number is not allowed to start with 911 (since this is reserved for emergency
use, and it would not be desirable for the system to wait to see whether more
digits were going to be dialed after someone has dialed 911).

*Solution*:
There are $$10^4$$ phone numbers that start with the prefix 911. Therefore,
there are

$$10^7 - 8\,000\,000 - 10^4 = 1\,990\,000$$

phone numbers that don't start with a 0, a 1 or 911.
