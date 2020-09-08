# Have 2 GET examples -- RCSB (GO) and UniProt XML record. (Both XML)
# Have 1 POST example (taken from EBI), only returns raw and HTML
#
use LWP::Simple;
use JSON; # not using, but LIB is there
use strict;

# GET example
#
my $url = "http://www.rcsb.org/pdb/rest/goTerms?structureId=4HHB";
my $browser = LWP::UserAgent->new;

# Issue request, with an HTTP header.
# This creates the request and gets it, all in one step
my $response = $browser->get($url,
  'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)',
);

die "Error getting $url" unless $response->is_success;
print 'Content type is ', $response->content_type;
print 'Content is:';
#print $response->content;


$url = "https://www.uniprot.org/uniprot/Q16539.xml";
#$url = "http://www.uniprot.org/uniprot/NOTTHE.xml";
my $response = $browser->get($url,
  'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)',
);
#my $filename = 'out_uniprot.txt';
if ($response->is_success) {
  print 'UniProt release ' . $response->header('X-UniProt-Release') .
  ' of ' . $response->header('Last-Modified') . "\n";
  print 'Content type is ', $response->content_type;
  print 'Content is:';
  print $response->content;
  #open(FH, '>', $filename) or die $!;
  #print FH $response->content;
}
else {
  die 'Failed, got ' . $response->status_line .
    ' for ' . $response->request->uri . "\n";
}

#print $response->status_line, '\n';
#print $response->request->uri, '\n';




