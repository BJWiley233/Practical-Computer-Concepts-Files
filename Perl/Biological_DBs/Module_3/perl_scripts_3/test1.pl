#! /usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use XML::Simple;
use XML::LibXML;
use Data::Dumper;


my $_id = "P32214";
my $ua = LWP::UserAgent->new;

=comment
my $response = $ua->get("https://www.uniprot.org/uniprot/$_id.xml",
					'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
unless ($response->is_success) {
	die 
	"https status: " . $response->code . "\n";
	'Failed, got ' . $response->status_line .
	' for ' . $response->request->uri . "\n";
}
=cut
my $xml = XML::Simple->new;

#my $data = $xml->XMLin($response->content);
my $data = $xml->XMLin("$_id.xml");

my $entry_node = $data->{entry};
my $name;
my $fullname;
my $seq;

#open(FH, '>', "out2.txt");
#print FH Dumper($data);
#close(FH);

if (defined($entry_node)) {

	$name = $entry_node->{name};
	$fullname = $entry_node->{protein}->{recommendedName}{fullName};
	$seq = $entry_node->{sequence}{content};
}
		
open(FHout, '>', "$_id.fasta");
print FHout "> $_id|$name|$fullname\n$seq"; 
