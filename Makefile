# file: Makefile
# auth: Andrew Alm <https://kzoo.tech>
# desc: Makefile for makeweb static website generator, see README.md for further
#       information.
# 
# Copyright (c) 2020, Andrew Alm <https://kzoo.tech>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY 
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, 
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM 
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR 
# PERFORMANCE OF THIS SOFTWARE.
#

.PHONY: all clean htdocs html
.SUFFIXES: .md .html

all: # default target

# default commands (things not typically found /bin), assume they are in $PATH
FIND := find 
PERL := PERL5LIB=$(.CURDIR)/perl5lib/ perl

# find all .md files in htdocs/ 
MDFILES != $(FIND) htdocs/ -type f -name "*.md"

.include "Makefile.site"

all: $(MDFILES:%.md=%.html)

.md.html: template.pl
	$(PERL) template.pl $< > $@

# clean htdocs 
clean:
	rm -f $(MDFILES:%.md=%.html)

