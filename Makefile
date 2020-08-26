.PHONY: all clean preview publish
.DEFAULT: all

.poison empty (PREVIEW-DIR)
.poison empty (PUBLISH-DIR)

# default settings
TOPDIR      != pwd
PREVIEW-CMD := true
PUBLISH-CMD := true

# default commands
SRC   != find src/ -type f -name "*.md" ! -name "index.md" | sed "s/src\///g"
PERL  := PERL5LIB=$(TOPDIR)/perl5lib/ perl
RSYNC := openrsync --rsync-path=openrsync

.include "Makefile.site"

# render html
all: $(SRC:%.md=html/%/index.html) html/index.html

html/index.html: src/index.md template.pl
	cd src/; $(PERL) ../template.pl index.md > ../html/index.html

.for page in $(SRC:%.md=%)
html/$(page)/index.html: src/$(page).md template.pl
	mkdir -p html/$(page)
	cd src/; $(PERL) ../template.pl $(page).md > ../html/$(page)/index.html
.endfor

# publish/preview using rsync; requires user-interaction
preview:
	$(PREVIEW-CMD)
	$(RSYNC) -r --del html/ $(PREVIEW-DIR)/

publish:
	$(PUBLISH-CMD)
	$(RSYNC) -r --del html/ $(PUBLISH-DIR)/

# remove build files
clean:
	rm -rf html/index.html
	for dir in $(SRC:%.md='%'); do \
		rm -rf html/$${dir};         \
	done

