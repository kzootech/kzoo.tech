# Building a Makefile-based Website
This guide documents a [Makefile-based][openbsd-man-make] website generator 
written to work with tools that are typically found on a "stock" BSD
installation. The generator parses [Markdown][fireball-markdown] files into HTML
pages, which can be served using any web server, such as OpenBSD's 
[httpd(8)][openbsd-man-make]. This guide loosely based on John Hawthorn's 
[This Website is a Makefile][hawthorn-make] article.

## template.pl 
The template file generates an HTML document from a valid Markdown file passed
in as the only command-line argument. This template can be modified to the needs
of a particular website. 
 
This file makes use of [Text::Markdown][cpan-markdown] to convert Markdown files
into HTML documents. Note that the Makefile adds perl5lib/ as an additional 
directory when searching for modules and Text/Markdown.pl can be installed
locally to this location.

This file contains some additional methods for adding
breadcrumbs and a date stamp to each HTML document rendered.

esyscmd(`sed -e "s/^/	/" template.pl')

## Makefile.site

## Makefile

	prompt# cat template.pl
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

## Downloads

[cpan-markdown]: https://metacpan.org/pod/Text::Markdown
[fireball-markdown]: https://daringfireball.net/projects/markdown
[openbsd-man-httpd]: https://man.openbsd.org/httpd
[openbsd-man-make]: https://man.openbsd.org/make
[hawthorn-make]: https://johnhawthorn.com/2018/01/this-website-is-a-makefile/

 
