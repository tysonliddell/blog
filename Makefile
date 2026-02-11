SITE := ./site
HTML_GEN_PROG := ./page_from_md.sh
TEMPLATE := template2

POSTS := $(patsubst %.md,$(SITE)/%.html,$(wildcard posts/*.md))
IMAGES := $(patsubst %,$(SITE)/%,$(wildcard assets/images/*))
FONTS := $(patsubst %,$(SITE)/%,$(wildcard assets/fonts/*))

.PHONY: all
all: $(POSTS) $(IMAGES) $(FONTS) tags

$(SITE)/posts/%.html: posts/%.md $(TEMPLATE) $(HTML_GEN_PROG) | $(SITE)/posts
	$(HTML_GEN_PROG) $< > $@

$(SITE)/assets/images/%: assets/images/% | $(SITE)/assets/images
	cp $< $@
	cp $(SITE)/assets/images/favicon.png $(SITE)/favicon.png

$(SITE)/assets/fonts/%: assets/fonts/% | $(SITE)/assets/fonts
	cp $< $@

.PHONY: tags
tags: $(TEMPLATE) $(HTML_GEN_PROG) | $(SITE)/tags
	-rm site/tags/*.tag
	grep -r '^tags:' ./posts | sed 's/:tags://' | sed 's/\.md/.html/' | awk '{ for (i=2; i<=NF; i++) printf("%s %s\n", $$i, $$1) }' | sort -r | awk '{ basename = $$2; gsub(/.*\//,"",basename); gsub(/.html/,"",basename); system("printf \"%s [%s](../%s)%s\n\" \"-\" "basename" "$$2" >> site/tags/"$$1".tag")}'
	for f in $$(ls site/tags/*.tag); do sed -i "1s/^/# $$(basename -s .tag $$f)\n/" $$f; $(HTML_GEN_PROG) $$f > $${f%.tag}.html; done
	-rm site/tags/*.tag

$(SITE)/posts:
	mkdir -p $(SITE)/posts

$(SITE)/assets/images:
	mkdir -p $(SITE)/assets/images

$(SITE)/assets/fonts:
	mkdir -p $(SITE)/assets/fonts

$(SITE)/tags:
	mkdir -p $(SITE)/tags

clean:
	rm -r $(SITE)
