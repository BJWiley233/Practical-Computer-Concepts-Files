#! /usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use XML::Simple;
use XML::LibXML;
use Data::Dumper;
use XML::LibXML::XPathContext;


my $_id = "P32214";
my $ua = LWP::UserAgent->new;

my $response = $ua->get("https://www.uniprot.org/uniprot/$_id.xml",
					'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
unless ($response->is_success) {
	die 
	"https status: " . $response->code . "\n";
	'Failed, got ' . $response->status_line .
	' for ' . $response->request->uri . "\n";
}

=comment
my $dom = XML::LibXML->load_xml(string => $response->content);
print ref($dom) . "\n";
print '$dom->nodeName is: ', $dom->nodeName . "\n";
my $uniprot = $dom->documentElement;
print '$uniprot->nodeName is: ', $uniprot->nodeName . "\n";
=cut
my $parser =  XML::LibXML->new;
my $doc = $parser->parse_string($response->content);
print ref($doc) . "\n";

foreach my $title ($doc->findnodes('/uniprot/entry/name')) {
    print $title->to_literal() . "\n";
}


		
