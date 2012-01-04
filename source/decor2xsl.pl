#!/usr/bin/perl

# Copyright 2011 Sean Hogan (http://meekostuff.net/)

use Cwd;
use File::Basename;
$PWD = getcwd();
$XSLTPROC = "/usr/bin/xsltproc --novalid --nonet";
($BINNAME,$BINPATH) = fileparse($0, ".pl");
$TEMPLATE = "$BINPATH$BINNAME.xsl";
$PARAMS = {};
$DECOR = "";
$IS_HTML = 0;
$VERBOSE = 0;
$SRC = "";

my $usage = "$0 [--html] [--verbose] file\n";

my $n = scalar @ARGV;
for (my $i=0; $i<$n; $i++) {
	my $arg = $ARGV[$i];
	if ("--help" eq $arg || "-?" eq $arg) {
		print STDERR $usage;
		exit 1;
	}
	elsif ("--html" eq $arg) {
		$IS_HTML = 1;
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

$SRCPATH = `dirname $SRC`;
chomp $SRCPATH;

my $execStr = "$XSLTPROC --path $SRCPATH --path $PWD $OUTARGS ";
$execStr .= ($IS_HTML) ? " --html " : "";
$execStr .= "$TEMPLATE $SRC";
$VERBOSE and print STDERR "$execStr\n";
system($execStr);
