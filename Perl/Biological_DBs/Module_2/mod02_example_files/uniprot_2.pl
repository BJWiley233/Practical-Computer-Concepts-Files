use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use strict;


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
    my $data = $xml->XMLin($response->content);
    #print Dumper($data);
    # Already know we want the "entry" element
    # This loop gives the first level under the root. 
    foreach my $key1 (keys %{$data}) {
      print "Key: $key1\n";
    }
    # This gives the level under the entry node
    my $entry_node = $data->{entry};
    if (defined($entry_node)) {
      while (my ($key, $value) = each(%$entry_node)) {
        # Some are true values, but some are references to other structures
        print "$key gives $value\n";
      }

      # Know accession gives an array
      my $acc_node = $entry_node->{accession};
      if (defined($acc_node)) {
        foreach my $val (@$acc_node) {
          print "Accession: $val\n";
        }
      }       

      # Know dbReference is a hash
      my $dbref = $entry_node->{dbReference};
      if (defined($dbref)) {
        while (my ($key, $value) = each(%$dbref)) {
           while (my ($subkey, $subvalue) = each(%$value)) {
            print "$key is  $subkey = $subvalue\n";
            if (($subkey eq "type") and ($subvalue eq "PDB")) {
              # For Q16539, it's only finding the PDBsum's with the same id
              print "dbRef $key is a PDB ID, $value\n";
            }
          }
        }
      } else {
        print "No dbReferences\n";
      }
    } else {
      print "No node named entry\n";
    }
  }
} else { 
  print "Error getting $url\n";
}



