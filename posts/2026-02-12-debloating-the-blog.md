```text
author: Tyson Liddell
tags: misc
```
# Debloating the blog build

As mentioned [previously][jekyll-issues], using Jekyll to build something as
simple as this blog was overkill. It now uses the following simpler structure:

- Pages written in the GitHub flavour of Markdown with no other extensions. The
  is simple, well supported and stable.
- The md4c C library is used to convert the markdown to html. This library is
  incredibly lean (3 small source files) and since I've vendored this library
  code into [a project that I own][md-to-html-repo] we achieve a
  dependency-free method for generating the site. No Jekyll, no problems.
- A Makefile orchestrates building the site by translating the markdown files
  into html and generating the tags/posts index pages.
- The site is built locally, zipped and uploaded to the web host through a
  `make` target.

This is clean, simple and minimal.

[jekyll-issues]: ./2026-01-29-jekyll-issues.html
[md-to-html-repo]: https://github.com/tysonliddell/md-to-html
