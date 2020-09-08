use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use JSON;
use strict;

my @my_pdbs;

my $uniprot_id = "Q16539";
my $url = "http://www.uniprot.org/uniprot/$uniprot_id.xml";
print "URL: $url\n";

my $browser = LWP::UserAgent->new;

my $response = $browser->get($url,
  'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');

if ($response->is_success) {
  # We got something
  print 'Content type is ', $response->content_type, "\n";
  if ($response->content_type eq "application/xml") {
    print "Process an XML response\n";
    my $xml = new XML::Simple();
    my $data = $xml->XMLin($response->content, 
	                   forcearray=>[qw(dbReference)],
                       keyattr=>[]);
    #print Dumper($data);
    # Already know we want the "entry" element
    # This loop gives the first level under the root. 
    foreach my $key1 (keys %{$data}) {
      print "Key: $key1\n";
    }
    # This gives the level under the entry node
    my $entry_node = $data->{entry};
    if (defined($entry_node)) {
      print "Handle dbref now\n";
      my $dbref = $entry_node->{dbReference};

      if (defined($dbref)) {
        foreach my $val (@$dbref) {
          if ($val->{type} && ($val->{type} eq "PDB") && ($val->{id})) {
            print "DB ref " . $val->{id} . " is a PDB\n";
            push(@my_pdbs, $val->{id});
		  } else {
            print "NOT PDB " . $val->{id} . "  " . $val->{type} . "\n";
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
if (length(@my_pdbs) > 0) {
  my %my_xml = ("UniProt" => $uniprot_id,
                "PDB" => \@my_pdbs);
  my $out_xml = new XML::Simple(NoAttr=>1, RootName=>'Proteins');
  my $out_data = $out_xml->XMLout(\%my_xml);
  print "$out_data\n";
  
  my $json = encode_json(\%my_xml);
  print "$json\n";
}

print scalar(@my_pdbs) . "\n";
