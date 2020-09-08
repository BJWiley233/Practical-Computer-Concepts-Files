#! /usr/bin/perl

use LWP;
use strict;
use warnings;
use Acme::Comment type => 'C++';

# Use RCSB PDB to get the GO terms associated with structure 4HHB
my $urlbase = "http://www.rcsb.org/pdb/rest/goTerms?structureId=";
my $pbd_id = '4hhb';

my $url = $urlbase . $pbd_id;

# Key/value pair arguments may be provided to set up the initial state.
# Meaning not a hash reference with brackets
# https://metacpan.org/pod/LWP::UserAgent
my $browser = LWP::UserAgent->new;


# Issue request, with an HTTP header.
# This next statement creates the request and gets it, all in one step.
# DO create a “user agent” – some services won’t return anything without it.
# can this "UA" field name be anything?

my $response = $browser->get($url,
		'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
if ($response->is_success) {
  print 'RCSB cache-control is ' . $response->header('Cache-Control') . "\n";
  print 'Day of download:  ' . $response->header('Date') . "\n";
  #print $response->headers()->as_string ;
  #print "\n";
  print 'Content type is '. $response->header('Content-Type') . "\n";
  print "Content is:\n";
  #print $response->content;
}
else {
  die 'Failed, got ' . $response->status_line .
    ' for ' . $response->request->uri . "\n";
}


/*
# And now for the UniProt call:
my $contact = 'bwiley4@jh.edu';
$url = "https://www.uniprot.org/uniprot/Q16539.xml";
my $agent = LWP::UserAgent->new(agent => "libwww-perl $contact");
my $response = $agent->get($url,
		'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
if ($response->is_success) {
  #print 'UniProt release ' . $response->header('X-UniProt-Release') .
  #' of ' . $response->header('Last-Modified') . "\n";
  print $response->headers()->as_string . '\n';
  print 'Content type is ', $response->content_type . '\n';
  print 'Content is:\n';
  #print $response->content;
}
else {
  die 'Failed, got ' . $response->status_line .
    ' for ' . $response->request->uri . "\n";
}
*/

