use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use strict;
use warnings;

# We'll get this record. Most of the time for a simple request like this URL
# you want to do a "get".
my $url = "http://www.uniprot.org/uniprot/Q16539.xml";
my $browser = LWP::UserAgent->new;

my $response = $browser->get($url,
  'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');

if ($response->is_success) {
  # We got something.
  print 'Content type is ', $response->content_type, "\n";
  if ($response->content_type eq "application/xml") {
    print "Process an XML response\n";
    my $xml = new XML::Simple();
    # The response->content has the information returned by the get call
    print $response->content;
    print "**********************************************************************\n";
    my $data = $xml->XMLin($response->content);
    # Let's see what we got. There is a lot there
    print Dumper($data);
  }
}  