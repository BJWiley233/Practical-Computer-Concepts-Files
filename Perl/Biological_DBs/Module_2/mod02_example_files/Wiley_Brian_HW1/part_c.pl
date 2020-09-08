#! /usr/bin/perl

use strict;
use warnings;

print "Type something in. \n";
# test with "Hi Hilly Hi terrain. Hightop hills and hi is cool so hi. hi ."
# or "hi Hilly bigHi Hi terrain. Hightop hills and hi is cool so hi. hi."
# or for subroutine "brian hi Hilly bigHi Hi terrain. Hightop hills"

my $entry = <STDIN>;
chomp $entry;

my $modified_entry;

## allowing to start with 'Hi' or 'hi' to do substitution
if ($entry =~ /^[Hh]i/) {
=comment
	Uses spaces or lines starts with so "Hi Hilly Hi terrain" is not
	replaced with 'Hello Hellolly Hello terrain". You can also combinde
	modifers 'g' for all entries and 'r' for non-descructive
	https://perldoc.perl.org/perlre.html#Modifiers
=cut
	## starts with
	$modified_entry = $entry =~ s/^Hi\s/Hello /gr;
	## or has space before, i.e. "bigHi" not replaced with "bigHello"
	$modified_entry =~ s/ Hi\s/ Hello /g;
	
	## lowercase start
	$modified_entry =~ s/^hi\s/hello /g;
	## doing twice so if followed by
	## space or end of a sentence with period
	$modified_entry =~ s/ hi\s/ hello /g;
	## need to escape the period 
	$modified_entry =~ s/ hi\./ hello./g;
	print $modified_entry . "\n";
} else {
	print "Value before subroutine = $entry\n";
	append_entry(\$entry);
	print "Value after subroutine  = $entry\n";
}


sub append_entry {
	
	# this is a reference to input scalar, i.e. the first reference
	my $string = $_[0];  
	
	# deference and append to the beginning of the dereference
	# used https://www.tek-tips.com/faqs.cfm?fid=427
	${$string} = "???" . ${$string};
}
	
	

