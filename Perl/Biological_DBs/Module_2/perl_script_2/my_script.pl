#! /usr/bin/perl

use LWP;
use XML::Simple;
use DBI;
use JSON;
use Data::Dumper;
use strict;
use warnings;

my @arrayOfHashes = ({"ID"=>1, "Value"=>"one"},
					 {"ID"=>2, "Value"=>"two"},
					 {"ID"=>3, "Value"=>"three"});

my $length = @arrayOfHashes;

print scalar(@arrayOfHashes), "\n";

=head2
test
test comment
=cut


foreach my $entry (@arrayOfHashes) {
	print "ID: $entry->{'ID'}, Value: $entry->{'Value'}\n";
}
