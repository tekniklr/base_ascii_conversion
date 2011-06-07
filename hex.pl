#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my ($help, $spaces, $hex, $ascii);

# read options
my $options = GetOptions (
	"help|?" => \$help,
	"spaces|s" => \$spaces,
	"hex|h=s" => \$hex,
	"ascii|a=s" => \$ascii
);

if ($help) {
	print "Usage: $0 [--help|-?] [--hex|-h <hex>] | [[--spaces|-s] --ascii|-a <ascii>]\n";
	exit;
}

if ((!$hex && !$ascii) || ($hex && $ascii)) {
	die "You must specify exactly one of -h and -a\n";
}
elsif ($hex) {
	convert_to_ascii($hex);
}
elsif ($ascii) {
	convert_to_hex($ascii);
}
else {
	die "What did you do? WHAT DID YOU DO?!?!\n";
}

sub convert_to_ascii {
	my $hex = shift @_;
	$hex =~ s/\s//g;
	($hex =~ /[^0-9a-fA-F]/) and die "That isn't hex.\n";
	my $length = length $hex;
	($length % 2) and die "That isn't something that will convert to ascii. (The number of characters needs to be a multiple of 2, you gave me ${length})\n";
	my @ascii=pack "H$length",$hex;
	print "@ascii\n";
}

sub convert_to_hex {
	my $ascii = shift @_;
	my $length = (length $ascii)*2;
	my $hex = unpack "H$length",$ascii;
	unless ($spaces) {
		my @pairs = ( $hex =~ m{ (.{2}) }xmsg );
		print "@pairs"."\n";
	}
	else {
		print $hex."\n";
	}
}
