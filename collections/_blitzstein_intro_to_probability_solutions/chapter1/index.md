---
layout: post
author: tyson
title: "Chapter 1 solutions"
source: "Introduction to Probability Second Edition"
source_author: "Blizstein, J. K. and Hwang, J."
chapter: 1

tags: probability solutions mathematics
hide_date: true
---

The following are my solutions to exercises in {{page.source}} by
{{page.source_author}}.

[All chapter {{page.chapter}} solutions](all)

{% assign
    exercises = site.blitzstein_intro_to_probability_solutions
    | where: 'is_exercise', true
    | where: 'chapter', page.chapter
%}
{% for page in exercises %}
[{{ page.title }}]({{ page.slug }})
{% endfor %}
