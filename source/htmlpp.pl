#!/usr/bin/perl

# Copyright 2009-2010 Sean Hogan (http://meekostuff.net/)
# TODO expand URIs in <xbl> trees

use 5.010;
use Cwd;
use File::Slurp;
use Mojo::DOM;
use URI::Template;

$PARAMS = {};
$SCRIPTS = [];
$POST_SCRIPTS = [];
$VERBOSE = 0;
$SRC = "";

my $usage = "$0 [--script scriptURL] [--post-script scriptURL] [--stringparam name value] file\n";

my $n = scalar @ARGV;
for (my $i=0; $i<$n; $i++) {
	my $arg = $ARGV[$i];
	if ("--help" eq $arg || "-?" eq $arg) {
		print STDERR $usage;
		exit 1;
	}
	elsif ("--stringparam" eq $arg) {
		my $name = $ARGV[++$i];
		my $value = $ARGV[++$i];
		$PARAMS->{$name} = $value;
		next;
	}
	elsif ("--script" eq $arg) {
		my $uri = $ARGV[++$i];
		push @{$SCRIPTS}, $uri;
		next;
	}
	elsif ("--post-script" eq $arg) {
		my $uri = $ARGV[++$i];
		push @{$POST_SCRIPTS}, $uri;
		next;
	}
	elsif ("--verbose" eq $arg) {
		$VERBOSE = 1;
		next;
	}
	elsif ($arg =~ /^-.+/) {
		print STDERR "Illegal option " . $arg . "\n" . "Usage:" . $usage;
		exit 1;
	}
	
	else {
		if (!$SRC) { $SRC = $arg; }
		else {
			print STDERR "Cannot process more than one file.\nUsage: " . $usage;
			quit();
		}
	}
}

my $text = read_file( $SRC );
my $doc = Mojo::DOM->new($text);
my $head = $doc->at("head");
my $body = $doc->at("body");

my $marker = $head->children->first;
foreach (@$SCRIPTS) {
	$marker->prepend("<script src=\"$_\"></script>\n");
}
$marker = $head->children->reverse->first;
foreach (@$POST_SCRIPTS) {
	$marker->append("<script src=\"$_\"></script>\n");
}

sub walkTree {
	my $node = shift; 
	my $callback = shift;
	!$node->type and return;
	&$callback($node);
	$node->children->each(sub { 
		my $node = shift; 
		walkTree($node, $callback); 
	});
}

walkTree($doc->children->first, sub {
	my $node = shift;
	my $attrName = {
		script => "src",
		img => "src",
		link => "href",
		a => "href",
		form => "action",
		input => "formaction",
		button => "formaction"
	}->{$node->type};
	my $uri = $node->attrs($attrName);
	!$uri and return;
	# FIXME warn for undefined URI variables
	$uri = URI::Template->new($uri)->process_to_string($PARAMS);
	$node->attrs($attrName => $uri);
});

print $doc;
