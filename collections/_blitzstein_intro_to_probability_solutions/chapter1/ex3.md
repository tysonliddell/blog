---
layout: post
author: tyson
title: "Exercise 1.9.3"
is_exercise: true
chapter: 1

usemathjax: true
hide_tags: true
---


**Exercise 1.9.3** Fred is planning to go out to dinner each night of a certain
week, Monday through Friday, with each dinner being at one of his ten favorite
restaurants.

**(a)** How many possibilities are there for Fred’s schedule of dinners for that
Monday through Friday, if Fred is not willing to eat at the same restaurant
more than once?

*Solution*:
On Monday Fred has 10 restaurants to choose from, on Tuesday 9, etc.
Therefore, there are

$$
10 \cdot 9 \cdot 8 \cdot 7 \cdot 6 = 30\,240
$$

ways Fred could schedule his dinners.

**(b)** How many possibilities are there for Fred’s schedule of dinners for that
Monday through Friday, if Fred is willing to eat at the same restaurant more
than once, but is not willing to eat at the same place twice in a row (or more)?

*Solution:*
On Monday Fred has 10 choices of restaurant. On all other days of the
week Fred has 9 choices (any restaurant other than the one he just visited).
Therefore, there are a total of

$$
10 \cdot 9^4 = 65\,610
$$

ways Fred could schedule his dinners.
