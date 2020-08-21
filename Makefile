.PHONY: all clean preview publish
.DEFAULT: all

.include "Makefile.site"

# commands
SRC   != find . -type f -name "*.md" ! -name "index.md" | sed "s/\.\///g"
PERL  := PERL5LIB=perl5lib/ perl
RSYNC := openrsync --rsync-path=openrsync

# render html
all: $(SRC:%.md=html/%/index.html) html/index.html

html/index.html: index.md template.pl
	$(PERL) template.pl index.md > html/index.html

.for page in $(SRC:%.md=%)
html/$(page)/index.html: $(page).md template.pl
	mkdir -p html/$(page)
	$(PERL) template.pl $(page).md > html/$(page)/index.html
.endfor

# publish/preview using rsync; requires user-interaction
preview:
	$(RSYNC) -r --del html/ $(PREVIEW-DIR)/

publish:
	$(RSYNC) -r --del html/ $(RELEASE-DIR)/

# remove build files
clean:
	rm -rf html/index.html
	for dir in $(SRC:%.md='%'); do \
		rm -rf html/$${dir};         \
	done

