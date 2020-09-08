#! /usr/bin/perl

use strict;
use warnings;
use test_class;
use feature qw/say/;

# key/value pairs (no brackets) instead of hash reference (brackets)
my $cube = test_class->new({
				length=>3, 
				width=>2, 
				#height=>6,
			});

my $volume = $cube->get_volume();

print $volume, "\n";
