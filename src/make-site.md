# make-site: A static website generator
Make-site is a simple [Makefile-based][openbsd-man-make] static website 
generator designed to work on a typical BSD installation. The generator parses
[Markdown][fireball-markdown] files into HTML documents, which can be hosted
on a any web server, such as [httpd(8)][openbsd-man-httpd]. Major features of 
make-site include:

* Incremental build system, only rebuild files that have changed;
* Markdown-based source files, easy to read and edit;
* Customizable template written in perl;
* Publish to either local or remote directory using rsync.

This utility was originally based on John Hawthorn's 
[This Website is a Makefile][hawthorn-make] article.

## Prerequisites 
The following software is required:

* [Perl][perl] (>=5.1.0),
* [rsync][openbsd-man-openrsync],
* [make][openbsd-man-make].

Note, a typical BSD installation should have all of the required software 
pre-installated.

A web server is required in order to serve the generated HTML documents. Refer 
to the appropriate documentation for proper configuration.

## Usage
Download and extract the gzip archive.

Source files should be placed in the *src/* sub-directory. The Makefile will
recursively search this directory for Markdown source files and generate 
corresponding HTML documents. 

HTML documents are generated and published by using [make(1)][openbsd-man-make].
The following Makefile targets can be invoked:

	all     - Generate HTML documents from Markdown source files. All generated
            documents will be put in the html/ directory.

	clean   - Remove all conents of the html/ directory.

	preview - Publish conents of html/ to the preview directory specified in the
            Makefile.site configuration file.

	publish - Publish html/ to web root directory specified in the Makefile.site
            configuration file.

Note that the preview and publish targets will not function without first 
creating a Makefile.site configuration file.

## Configuration
For full functionality, some settings must be configured by creating a
Makefile.site file. A sample Makefile.site is listed below:


	$ cat Makefile.sample.site
	# required settings
	PUBLISH-DIR := admin@example.bar:/var/www
	PREVIEW-DIR := admin@example.com:/var/www/btBB02peqas4VryxjN2sKCsC73PLgTry

	# optional settings
	PUBLISH-CMD := -( git add *; git commit; git push -u github main; )
	#PREVIEW-CMD := 

	# default command, uncomment and modify to override
	#SRC   != find src/ -type f -name "*.md" ! -name "index.md" | sed "s/src\///g"
	#PERL  := PERL5LIB=$(TOPDIR)/perl5lib/ perl
	#RSYNC := openrsync --rsync-path=openrsync

The preview and publish targets use [openrsync(1)][openbsd-man-openrsync] and so
both local and remote (ssh) directories can be used. Remote directories may
require user interactive for password input. 

Note that all defaults are set before *Makefile.site* is parsed, and so any setting may
be adjusted in this file.

## Template
For each markdown file the template.pl script is used to generate the final HTML
document. This file can be customized to change the resulting HTML document.
Modifying this file will cause all pages to be re-generated.

Note that this script uses [Text::Markdown][cpan-markdown] to convert Markdown
syntax to HTML. This is expected to be found in the *perl5lib/* directory.
	
## Downloads

* [make-site1a.tar.gz][kzoo-make-site1a] (732 kB)

## History

**2020-Aug-26, Release 1a**

*Initial release.*

[cpan-markdown]: https://metacpan.org/pod/Text::Markdown
[fireball-markdown]: https://daringfireball.net/projects/markdown
[github-kzoo-makefile]: https://github.com/kzootech/kzoo.tech/blob/main/Makefile
[github-kzoo-template]: https://github.com/kzootech/kzoo.tech/blob/main/template.pl
[hawthorn-make]: https://johnhawthorn.com/2018/01/this-website-is-a-makefile/
[kzoo-make-site1a]: https://kzoo.tech
[openbsd-man-httpd]: https://man.openbsd.org/httpd
[openbsd-man-make]: https://man.openbsd.org/make
[openbsd-man-openrsync]: https://man.openbsd.org/openrsync
[perl]: https://perl.org

 
