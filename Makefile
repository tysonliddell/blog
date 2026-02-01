SITE := ./site
html-gen-prog = ../../md-to-html/md-to-html

POSTS := $(patsubst %.md,$(SITE)/%.html,$(wildcard posts/*.md))
IMAGES := $(patsubst %,$(SITE)/%,$(wildcard assets/images/*))

.PHONY: all
all: $(POSTS) $(IMAGES) tags

$(SITE)/posts/%.html: posts/%.md | $(SITE)/posts
	cat $? | $(html-gen-prog) > $@

$(SITE)/assets/images/%: assets/images/% | $(SITE)/assets/images
	cp $? $@

.PHONY: tags
tags: | $(SITE)/tags
	echo TODO: Add tags

$(SITE)/posts:
	mkdir -p $(SITE)/posts

$(SITE)/assets/images:
	mkdir -p $(SITE)/assets/images

$(SITE)/tags:
	mkdir -p $(SITE)/tags

clean:
	rm -r $(SITE)
