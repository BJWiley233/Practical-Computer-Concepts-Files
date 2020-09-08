#! /usr/bin/perl

use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use strict;
use warnings;
use Acme::Comment type => 'C++';


#my $filename = "proc_xml1.txt";
my $filename = "proc_xml1.xml";
my $url = 'https://www.uniprot.org/uniprot/Q16539.xml';
my $agent = LWP::UserAgent->new;
my $xml = XML::Simple->new;



#my $response = $agent->get($url,
#	'UA' => 'Mozilla/4.0 (compatible; MSIE 7.0)');

my $data; 
$data = $xml->XMLin($filename);
my $entry_node = $data->{entry};


=item stuff()

 This function does stuff.
 
=cut

sub stuff {
	$_[0] = 1;
    $_[1] = 2;
}

=pod

Remember to check its return value, as in:

  stuff() || die "Couldn't do stuff!";
  
=cut

if (defined($entry_node)) {
	while (my ($key, $value) = each(%$entry_node)) {
		print "$key gives $value\n";
	}
}



