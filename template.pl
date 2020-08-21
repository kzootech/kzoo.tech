#!/usr/bin/perl
# file: bin/render.pl
# auth: Andrew Alm <contact@kzoo.tech>
# desc: HTML rendering scripts for kzoo.tech websites which converts markdown
#       files into stand-alone HTML documents.
use 5.10.0;
use strict;
use warnings;

# modules
use File::Spec;
use POSIX;
use Text::Markdown;

sub breadcrumbs { # navigational breadcrumbs
	my ($vol, $dirs, $file) = File::Spec->splitpath(@_);
	my $url = "https://kzoo.tech";
	my $html = "[<a href=\"$url\">kzoo.tech</a>]\n";

	foreach my $dir (File::Spec->splitdir($dirs)) {
		$url  .= "/$dir";
		$html .= " / [<a href='$url'>$dir</a>]\n";
	}

	$file =~ s/\.md//;
	if ("index" ne $file) {
		$html .= " / [<a href='$url/$file'>$file</a>]\n";
	}

	return $html;
}

sub datestamp { # modify time of file
	my $date = POSIX::strftime("%Y %b %d", localtime((stat($_[0]))[9]));
	return "Last Modified: $date";
}

sub markdown { # generate html from md
	my $md = Text::Markdown->new(empty_element_suffix => '>', tab_width => 2); 
	return $md->markdown($_[0]);
}

# render html 
if (0 != $#ARGV) { # 1 argument only
	die "usage: render.pl [file]";
}

open my $fh, "<", $ARGV[0] or die "cannot read file";
my $header  = breadcrumbs($ARGV[0]);
my $content = markdown(do { local $/; <$fh> });
my $footer  = datestamp($ARGV[0]);

print <<EOF;
<!DOCTYPE html>
<html>
<head>
	<title>kzoo.tech</title>

	<style>
		:root {
			--palette1: #f2f3f0; /* white */
			--palette2: #8e8d80; /* olive */
			--palette3: #939aa0; /* grey */
			--palette4: #876759; /* brown */
			--palette5: #3a3336; /* black */
		}

		body {
			background-color: var(--palette5);
			color: var(--palette2);
			margin: 5em auto;
			max-width: 35em;
		}

		h1,h2,h3,h4,h5 {
			color: var(--palette4);
		}

		a {
			color: var(--palette3);
		}

		code {
			color: var(--palette1);
			background-color: rgba(0,0,0,.5);
			display: block;
			padding: 1em;
			overflow: hidden;
			font-size: small;
		}

		header {
			background-color: var(--palette5);
			position: fixed;
			top: 0;
			margin: 0 auto;
			width: 50em;
			padding: 1em 0;
			vertical-align: bottom;
			font-size: small;
			user-select: none;
		}

		footer {
			text-align: right;
			font-style: italic;
			font-size: small;
		}
	</style>
</head>
<body>
<header>
$header
</header>
$content
<footer>
$footer
</footer>
</body>
</html>
EOF

