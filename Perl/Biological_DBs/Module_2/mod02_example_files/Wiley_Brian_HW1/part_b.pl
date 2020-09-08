#! /usr/bin/perl

use strict;
use warnings;


my $string = "I have a string of words";
## https://perldoc.perl.org/functions/split.html; split /PATTERN/,EXPR
my @arr = split(" ", $string);
print scalar(@arr) . " words\n";

my $new_string = join(",", @arr);
print $new_string . "\n";
