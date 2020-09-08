#! /usr/bin/perl

use strict;
use warnings;

open(FHin, "<:encoding(utf8)", "HW_1_D.txt") or die $!;
open(FHout, ">:encoding(utf8)", "HW_1_D_out.txt");

## not sure if we need this line
local $/ = "\n";

my $new_file = "HW_1_D_out.txt";

while(<FHin>) {
	## see chomp() is confusing: https://www.perlmonks.org/?node_id=549385
	$_ =~ s/\r?\n$//;
	## pass reference
	trim(\$_);
	## in order to have only 2 letters and not any letters before
	## 2 letters must anchor to beginning of string
	if ($_ =~ /^[a-zA-Z]{2}[0-9]{4,5}/) {
		#print $_ . "\n";
		print FHout $_ . "\n";
	} else {
		print "Error! $_" . " is not well formed\n";
	}
}

close(FHout);
close(FHin);


## for trimmming; from part_e that I did first
## see https://perlmaven.com/trim
sub trim {
	my $string = shift;
	## regex substitution with g modifier
	## need to dereference, I like to use '{}' for dereference
	${$string} =~ s/^\s+|\s+$//g; 

}
