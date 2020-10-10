#! /usr/bin/perl

=comment
Script 2 (50 pts)
Just using XML::Simple since only reading XML
=cut

use strict;
use warnings;
use LWP::UserAgent;
use XML::Simple;
use DBI;
use Data::Dumper;


my $id = "Q02293";
## set UserAgent
my $ua = LWP::UserAgent->new;

## get Uniprot response
my $response = $ua->get("https://www.uniprot.org/uniprot/$id.xml",
			'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
unless ($response->is_success) {
	die "https status: " . $response->code . "\n";
		 "Failed, got " . $response->status_line .
		 " for " . $response->request->uri . "\n";
}

## get XML
my $xml = XML::Simple->new;
my $data = $xml->XMLin($response->content,
						  ForceArray=>[qw(dbReference)],
						  KeyAttr=>[]);
						  
my $entry_node = $data->{entry};
my $fullname = $entry_node->{protein}->{recommendedName}{fullName};
if (ref $fullname eq "HASH") {
	print "yes\n";
	print $entry_node->{protein}->{recommendedName}{fullName}{content} . "\n";
}
print $entry_node->{protein}->{recommendedName}{fullName}{content} . "\n";

open (FH, ">", "script2_fixed2.txt");
print FH Dumper $data;
