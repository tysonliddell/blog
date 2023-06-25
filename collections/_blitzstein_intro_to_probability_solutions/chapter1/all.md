---
layout: post
author: tyson
title: "All chapter 1 solutions"
source: "Introduction to Probability Second Edition"
source_author: "Blizstein, J. K. and Hwang, J."

usemathjax: true
hide_date: true
hide_tags: true
---

The following are my solutions to exercises in {{page.source}} by
{{page.source_author}}.
<hr>

{% assign
    exercises = site.blitzstein_intro_to_probability_solutions
    | where: 'is_exercise', true
    | where: 'chapter', 1
%}
{% for page in exercises %}
{{ page.content }}
<hr>
{% endfor %}
