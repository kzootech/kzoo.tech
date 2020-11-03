#!/usr/bin/perl
# file: template.pl
# auth: Andrew Alm <https://kzoo.tech>
# desc: Generates and HTML5 document from the Markdown file passed as a command
#       line argument. See README.md for further information.
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

use 5.10.0;
use strict;
use warnings;

# modules
use File::Spec;
use POSIX;
use Text::Markdown;

# globals
my $title = "kzoo.tech";

sub breadcrumbs { # navigational breadcrumbs
	my ($vol, $dirs, $file) = File::Spec->splitpath(@_);
	my $url = "";
	my $html = "[<a href=\"$url/\">$title</a>]";

	foreach my $dir (File::Spec->splitdir($dirs)) {
		next if "htdocs" eq $dir || "" eq $dir;
		$url  .= "/$dir";
		$html .= " / [<a href='$url'>$dir</a>]";
	}

	$file =~ s/\.md//; # remove file extension 
	if ("README" ne $file) {
		$html .= " / [<a href='$url/$file'>$file</a>]";
	}

	return $html;
}

sub datestamp { # modify time of file
	my $date = POSIX::strftime("%d-%b-%Y", localtime((stat($_[0]))[9]));
	return "$date";
}

sub markdown { # generate html from md
	open my $fh, "<", $_[0] or die "cannot read file";
	my $md = Text::Markdown->new(empty_element_suffix => '>', tab_width => 2); 
	return $md->markdown(do { local $/; <$fh> } );
}

# render html 
if (0 != $#ARGV) { # 1 argument only
	die "usage: template.pl [file]";
}

my $header  = breadcrumbs($ARGV[0]);
my $article = markdown($ARGV[0]);
my $footer  = datestamp($ARGV[0]);

print <<EOF;
<!DOCTYPE html>
<html>
<head>
	<title>makeweb</title>
	<link rel="stylesheet" href="/style.css">
</head>
<body>
	<header>$header</header>
	<article>$article</article>
	<footer>Last Updated: $footer</footer>
</body>
</html>
EOF

