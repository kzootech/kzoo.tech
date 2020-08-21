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
	m4 $(page).md > html/$(page)/index.md
	$(PERL) template.pl html/$(page)/index.md > html/$(page)/index.html
	rm html/$(page)/index.md
.endfor

# publish/preview using rsync; requires user-interaction
preview:
	$(RSYNC) -r --del html/ $(PREVIEW-DIR)/

publish:
	-git add *
	-git commit
	-git push -u github master
	$(RSYNC) -r --del html/ $(RELEASE-DIR)/

# remove build files
clean:
	rm -rf html/index.html
	for dir in $(SRC:%.md='%'); do \
		rm -rf html/$${dir};         \
	done

