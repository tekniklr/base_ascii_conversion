#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my ($help, $spaces, $binary, $ascii);

# read options
my $options = GetOptions (
	"help|h|?" => \$help,
	"spaces|s" => \$spaces,
	"binary|b=s" => \$binary,
	"ascii|a=s" => \$ascii
);

if ($help) {
	print "Usage: $0 [--help|-h|-?] [--binary|-b <binary>] | [[--spaces|-s] --ascii|-a <ascii>]\n";
	exit;
}

if ((!$binary && !$ascii) || ($binary && $ascii)) {
	die "You must specify exactly one of -b and -a\n";
}
elsif ($binary) {
	convert_to_ascii($binary);
}
elsif ($ascii) {
	convert_to_binary($ascii);
}
else {
	die "What did you do? WHAT DID YOU DO?!?!\n";
}

sub convert_to_ascii {
	my $binary = shift @_;
	$binary =~ s/\s//g;
	($binary =~ /[^01]/) and die "That isn't binary.\n";
	my $length = length $binary;
	($length % 8) and die "That isn't something that will convert to ascii. (The number of characters needs to be a multiple of 8, you gave me ${length})\n";
	my @ascii=pack "B$length",$binary;
	print "@ascii\n";
}

sub convert_to_binary {
	my $ascii = shift @_;
	my $length = (length $ascii)*8;
	my $binary = unpack "B$length",$ascii;
	if ($spaces) {
		my @octets = ( $binary =~ m{ (.{8}) }xmsg );
		print "@octets"."\n";
	}
	else {
		print $binary."\n";
	}
}
