# My blog
## Purpose
- To document the things I learn/build/discover.
- To help synthesise my knowledge.
- It's not written for any particular audience other than myself.

## Generating the site
Run `make` to build the site. It will be put in the `site` directory.  Uses my
`md-to-html` tool (an `md4c` wrapper) to transform the Markdown to HTML.

## Directory layout
```
|-- assets (contains images, css, etc.)
|   |-- css
|   |   `-- style.css
|   |-- images
|       `-- composite-video
|           |-- image1.png
|           ...
|           `-- imageN.png
|-- posts
|   |-- 2000-01-01-some-post.md
|   ...
|   `-- 2026-12-31-some-post.md
|-- site (generated directory containing built site)
    |-- assets (as above)
    |-- posts (as above with .md files converted to .html)
    |-- tags
        |-- microcontrollers.html (contains links to all microcontroller tagged pages, in desc date order)
        |-- composite-video-experiment.html
        |-- 8088.html
        `-- ibm-pc.html
|-- README.md
|-- LICENCE
|-- main.md
```

## Templating/linking
Keep it simple. The only way pages can be grouped is by tags. For each tag
`foo` we find, we create `tags/foo.html` and put links to all corresponding
related pages on that page. We'll create some kind of header in the Markdown
containing the tags.

We don't provide any Markdown extention to link between Markdown documents.
These posts will primarily be read from my terminal. We avoid interleaving
external links with Markdown prose. Links should be added as a list to the end
of the page and should have short names. For example:

> as we see in the foo library docs[foo], this operation is not supported
> ...
> [foo]: foodocs.com

## The header
Example header (keep it simple):
```
---
author: Tyson Liddell
tags: 8088 IBM-PC
---
```
