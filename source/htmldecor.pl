#!/usr/bin/perl -X

# Copyright 2009-2012 Sean Hogan (http://meekostuff.net/)

use 5.010;
use Cwd;
use Mojo::DOM;
use File::Slurp;

$DECOR = "";
$WRAP = false;
$VERBOSE = 0;
$SRC = "";

my $usage = "$0 [--wrap] [--decor decorURL] file\n";

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
	elsif ("--wrap" eq $arg) {
		$WRAP = true;
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
# WARN assuming that document head and body exist
my $head = $doc->at("head");
my $body = $doc->at("body");

my $srcNode;
my $marker = $head->children->first;
foreach $srcNode ($decorHead->children->each) {
	($srcNode->type eq 'title' && $head->at("title")) and next;
	($srcNode->type eq 'meta' && $srcNode->attrs('http-equiv')) and next;
        if ($marker) { $marker->prepend("$srcNode\n"); }
        else { $head->append_content("$srcNode\n"); }
}

$body->replace($decorBody);
if ($WRAP) {
	my $target = $doc->at('*[role="main"]') or die "No wrapper marked with \@role='main'";
	$target->replace_content();
	$body->children->each(sub {
		my $srcNode = shift;
		$target->append_content($srcNode);
	});
}
else {
	$body->children->each(sub {
		my $srcNode = shift;
		my $id = $srcNode->attrs('id');
		$id and $marker = $doc->at("body")->at("#$id");
		$marker and $marker->replace($srcNode);
	});
}

print $doc;
