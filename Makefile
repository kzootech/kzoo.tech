.PHONY: all clean preview publish
.DEFAULT: all

# default commands
SRC   != find src -type f -name "*.md" ! -name "index.md" | sed "s/src\///g"
PERL  := PERL5LIB=perl5lib/ perl
RSYNC := openrsync --rsync-path=openrsync

.include "Makefile.site"

# render html
all: $(SRC:%.md=html/%/index.html) html/index.html

html/index.html: src/index.md template.pl
	$(PERL) template.pl src/index.md > html/index.html

.for page in $(SRC:%.md=%)
html/$(page)/index.html: src/$(page).md template.pl
	mkdir -p html/$(page)
	$(PERL) template.pl src/$(page).md > html/$(page)/index.html
.endfor

# publish/preview using rsync; requires user-interaction
preview:
	$(RSYNC) -r --del html/ $(PREVIEW-DIR)/

publish:
	-git add *
	-git commit
	-git push -u github main 
	$(RSYNC) -r --del html/ $(RELEASE-DIR)/

# remove build files
clean:
	rm -rf html/index.html
	for dir in $(SRC:%.md='%'); do \
		rm -rf html/$${dir};         \
	done

