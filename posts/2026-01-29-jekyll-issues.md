```text
author: Tyson Liddell
tags: misc
```
# Static site generation issues

I tried to get this blog up and running again after it lay dormant for a few
years. Unfortunatly, I ran into a few issues:
- The current setup uses the static site generator Jekyll to convert my
  markdown to HTML.
- I followed the Jekyll guide to install Ruby and attempt to get everything set
  up.
- Ran into issues with Ruby not finding gems (sudo vs non-sudo install)
- `bundler` tool in my `Gemfile.lock` was quite old and Ruby initially had
  issues trying to auto-downgrade it.
- A bunch of dependencies were missing after I ran `bundle install`, not sure
  why.
- Jekyll installs a large number of dependencies for a task that is not that
  complex as a user (`.md` -> `.html`).
- Ruby makes a bit of a mess of my system, since I don't understand it.

Given all of this, I think I should write my own static site generator that can
convert Markdown to HTML. I don't need anything fancy, but it should be free of
all external dependencies. I just need a simple CLI tool (a dependency-free
binary) that can parse my simple flavor of markdown and convert it to HTML.

TODO: Check if a tool like this already exists. Search for "dependency free
static site generator".

TODO: Consider just keeping all thoughts together in pure Markdown. Do I need
to convert these to HTML? Could I just have a single page with a list of links
to raw `.md` files? Might be easiest.
