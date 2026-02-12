SITE := ./site
HTML_GEN_PROG := ./tools/page_from_md.sh
TEMPLATE := ./templates/template2

PAGES := $(patsubst pages/%.md,$(SITE)/%.html,$(wildcard pages/*.md))
POSTS := $(patsubst %.md,$(SITE)/%.html,$(wildcard posts/*.md))
IMAGES := $(patsubst %,$(SITE)/%,$(wildcard assets/images/*))
FONTS := $(patsubst %,$(SITE)/%,$(wildcard assets/fonts/*))

.PHONY: all
all: posts $(PAGES) images $(FONTS) tags

$(SITE)/posts/%.html: posts/%.md $(TEMPLATE) $(HTML_GEN_PROG) | $(SITE)/posts
	$(HTML_GEN_PROG) $< > $@

$(SITE)/%.html: pages/%.md $(TEMPLATE) $(HTML_GEN_PROG) | $(SITE)
	$(HTML_GEN_PROG) $< > $@

$(SITE)/assets/images/%: assets/images/% | $(SITE)/assets/images
	cp $< $@

$(SITE)/assets/fonts/%: assets/fonts/% | $(SITE)/assets/fonts
	cp $< $@

.PHONY: posts
posts: $(POSTS)
	rm -f $(SITE)/posts/index.html
	cd $(SITE)/posts && ls -r *.html | sed 's/\(.*\).html/- [\1](\1.html)/' | awk 'BEGIN {print "# posts"} {print}' > index.md
	$(HTML_GEN_PROG) $(SITE)/posts/index.md > $(SITE)/posts/index.html
	rm $(SITE)/posts/index.md

.PHONY: images
images: $(IMAGES)
	cp $(SITE)/assets/images/favicon.png $(SITE)/favicon.ico

.PHONY: tags
tags: $(TEMPLATE) $(HTML_GEN_PROG) | $(SITE)/tags
	rm -f $(SITE)/tags/*.tag
	grep -r '^tags:' ./posts | sed 's/:tags://' | sed 's/\.md/.html/' | awk '{ for (i=2; i<=NF; i++) printf("%s %s\n", $$i, $$1) }' | sort -r | awk '{ basename = $$2; gsub(/.*\//,"",basename); gsub(/.html/,"",basename); system("printf \"%s [%s](../%s)%s\n\" \"-\" "basename" "$$2" >> $(SITE)/tags/"$$1".tag")}'
	for f in $$(ls $(SITE)/tags/*.tag); do sed -i "1s/^/# $$(basename -s .tag $$f)\n/" $$f; $(HTML_GEN_PROG) $$f > $${f%.tag}.html; done
	cd $(SITE)/tags && ls *.html | sed 's/\(.*\).html/- [\1](\1.html)/' | awk 'BEGIN {print "# tags"} {print}' > index.tag
	$(HTML_GEN_PROG) $(SITE)/tags/index.tag > $(SITE)/tags/index.html
	rm -f $(SITE)/tags/*.tag

$(SITE):
	mkdir -p $(SITE)

$(SITE)/posts:
	mkdir -p $(SITE)/posts

$(SITE)/assets/images:
	mkdir -p $(SITE)/assets/images

$(SITE)/assets/fonts:
	mkdir -p $(SITE)/assets/fonts

$(SITE)/tags:
	mkdir -p $(SITE)/tags

.PHONY: deploy
deploy: all
	cd $(SITE) && zip --filesync -r ../$(SITE).zip .
	curl -H "Authorization: Bearer $(NETLIFY_API_KEY)" -H "Content-Type: application/zip" -X POST --data-binary "@$(SITE).zip" https://api.netlify.com/api/v1/sites/1b8c5836-6ea3-42e9-a047-ef33e4258462/builds

clean:
	rm -rf $(SITE)
	rm -f $(SITE).zip
