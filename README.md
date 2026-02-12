# Blog
## Generating the site
Run `make` to build the site. It will be put in the `site` directory.  Uses my
[`md-to-html` tool][md-to-html-repo] (an `md4c` wrapper) to transform the
Markdown to HTML.

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

[md-to-html-repo]: https://github.com/tysonliddell/md-to-html
