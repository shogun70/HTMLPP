#!/usr/bin/perl

# Copyright 2009-2012 Sean Hogan (http://meekostuff.net/)

use 5.010;
use Cwd;
use Mojo::DOM;
use File::Slurp;

$DECOR = "";
$VERBOSE = 0;
$SRC = "";

my $usage = "$0 [--decor decorURL] file\n";

my $n = scalar @ARGV;
for (my $i=0; $i<$n; $i++) {
	my $arg = $ARGV[$i];
	if ("--help" eq $arg || "-?" eq $arg) {
		print STDERR $usage;
		exit 1;
	}
	elsif ("--decor" eq $arg) {
		my $uri = $ARGV[++$i];
		$DECOR = $uri;
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


my $decorText = read_file( $DECOR );
my $decorDoc = Mojo::DOM->new($decorText);
my $decorHead = $decorDoc->at("head");
my $decorBody = $decorDoc->at("body");

my $text = read_file( $SRC );
my $doc = Mojo::DOM->new($text);
my $head = $doc->at("head");
my $body = $doc->at("body");

my $srcNode;
my $marker = $head->children->first;
foreach $srcNode ($decorHead->children->each) {
	($srcNode->type eq 'title' && $head->children("title")) and next;
	($srcNode->type eq 'meta' && $srcNode->attrs('http-equiv')) and next;
	$marker->prepend("$srcNode\n");
}

$body->replace($decorBody);
foreach $srcNode ($body->children->each) {
	my $id = $srcNode->attrs('id');
	if ($id && ($marker = $doc->at("body")->at("#$id"))) {
		$marker->replace($srcNode);
	}
}

print $doc;
