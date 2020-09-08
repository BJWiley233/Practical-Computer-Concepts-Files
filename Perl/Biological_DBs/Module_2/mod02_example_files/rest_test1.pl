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

#die "Error getting $url" unless $response->is_success;
#print 'Content type is ', $response->content_type;
#print 'Content is:';
if ($response->is_success) {
  print 'UniProt release ' . $response->header('X-UniProt-Release') .
  ' of ' . $response->header('Last-Modified') . "\n";
  #print 'Content type is ', $response->content_type;
  #print 'Content is:';
  print $response->content;
}
else {
  die 'Failed, got ' . $response->status_line .
    ' for ' . $response->request->uri . "\n";
}

#print $response->status_line, '\n';
#print $response->request->uri, '\n';




print "====================================================\n";


# FROM EBI TUTORIAL
my $db = 'uniprotkb'; # Database: UniProtKB
my $id = 'Q16539'; # Entry identifiers
my $format = 'uniprot'; # Result format
my $style = 'raw'; # Result style
 
# Create a user agent
my $ua = LWP::UserAgent->new();
 
# URL for service (endpoint)
my $url = 'http://www.ebi.ac.uk/Tools/dbfetch/dbfetch';
 
# Populate POST data fields (key => value pairs)
my (%post_data) = (
		   'db' => $db,
		   'id' => $id,
		   'format' => $format,
		   'style' => $style
		   );
 
# Perform the request
my $response = $ua->post($url, \%post_data);
 
# Check for HTTP error codes
die 'http status: ' . $response->code . ' ' . $response->message unless ($response->is_success); 
 
# Output the entry
print $response->content();



print "******************************************************************\n";
$response = $ua->post($url,
	['db'=>$db, 'id'=>'P69905', 'format'=>$format, 'style'=>$style]);

die 'http status: ' . $response->code . ' ' . $response->message unless ($response->is_success); 
 
# Output the entry
print $response->content();


