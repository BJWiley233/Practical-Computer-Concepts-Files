#! /usr/bin/perl

use LWP::Simple;
use XML::Simple qw(:strict);
use Data::Dumper;
use strict;
use Hash::Ordered; # https://metacpan.org/pod/Hash::Ordered#iterator


my @uniprot_ids = ("Q9BXH1", "Q16539", "Q9Y5W5"); # Puma!!, MAPK, WIF1
my $agent = LWP::UserAgent->new;
## this would store list of UniProts which PDB IDs as children that each have properties
my %proteins;

## used for testing different methods of protein structure determination
my @all_pdbs;
my @my_xray_pdbs;
my @my_nmr_pdbs;

=comment
Iterate through uniprot ids to get their PBD id with property for 
method of structure determination
Data strutructure is as follows:
proteins{UniProtID}{PDB IDs}{'property'}[OrderedDict(type="method", value="structure determination method")]
=cut
foreach my $uniprot_id (@uniprot_ids) {
	my $url = "https://www.uniprot.org/uniprot/$uniprot_id.xml";
	my $response = $agent->get($url,
						'UA' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
	my $xml = XML::Simple->new;
	my $data = $xml->XMLin($response->content,
					       ForceArray=>[qw(dbReference)],
					       KeyAttr=>[]);
	my $entry_node = $data->{entry};
	if (defined($entry_node)) {
		## We have an entry to add protein being the UniProt ID
		$proteins{$uniprot_id} =  {};
		my $dbref = $entry_node->{dbReference};
		if (defined($dbref)) {
			foreach my $val (@$dbref) {
				if ($val->{type} && ($val->{type} eq 'PDB') && ($val->{id})) {
					## We have PDB entries
					push(@all_pdbs, $val->{id});
					$proteins{$uniprot_id}{$val->{id}} = {};
					my $property = $val->{property};
					if (defined($property)) {
						foreach my $prop (@$property) {
							## Only doing 1 property for now (method of determination).  Edit below here for more properties
							if ($prop->{value} eq 'X-ray') {
								## code to add X-ray entry to our tree structure
								my $prop_ordered = Hash::Ordered->new(type  => "method",
																	  value => "X-ray");
								$proteins{$uniprot_id}{$val->{id}}{'property'} = [$prop_ordered]; 
								push(@my_xray_pdbs, $val->{id})
								
							}
							if ($prop->{value} eq 'NMR') {
								## code to add NMR entry to our tree structure
								push(@my_nmr_pdbs, $val->{id});
								my $prop_ordered = Hash::Ordered->new(type  => "method",
																	  value => "NMR");
								$proteins{$uniprot_id}{$val->{id}}{'property'} = [$prop_ordered];
							}
						}
					}			
				} else {
					print "Type not PDB for " . $val->{id} . " Type is " . $val->{type} . "\n";
				}
			}
		} else {
			print "No dbRef\n";
		}
	} else {
		print "No entry\n";
	}
}


## confirm list see if there is another method besides X-ray and NMR
print scalar(@all_pdbs) . "\n";
print scalar(@my_xray_pdbs) . "\n";
print scalar(@my_nmr_pdbs) . "\n";


if (length(@all_pdbs) > 0) {

	my %my_xml = ("UniProt" => $uniprot_ids[0],
                  "PDB" => \@all_pdbs);
    my $out_xml = new XML::Simple(NoAttr=>1, RootName=>'Proteins');
    my $out_data = $out_xml->XMLout(\%my_xml, KeyAttr=>[]);
    print "$out_data\n";
  
}


=comment
Write in form:
<Proteins>
	<UniProt id="Q16539">
		<PDB id="1A9U">
			<property type="method" value="X-ray"/>
		</PDB>
		...
		...
	</UniProt>
	<UniProt id="Q9Y5W5">
		<PDB id="2D3J">
			<property type="method" value="NMR"/>
		</PDB>
		...
		...
	</UniProt>
</Proteins>
=cut
## just printing to confirm structure of stored data from XML::Simple::XMLin
#print $proteins{$uniprot_ids[0]}{'2M04'}{'property'}[0]->get('type') . "\n"; # see https://metacpan.org/pod/Hash::Ordered#get
#print $proteins{$uniprot_ids[0]}{'2M04'}{'property'}[0]->get('value') . "\n";


## https://metacpan.org/pod/XML::LibXML
## this tutorial helped http://www.streppone.it/cosimo/blog/2010/05/how-to-generate-an-xml-document-with-xmllibxml/
## so is this one (Grant McLean is a great resource.  Very active on `Stackoverflow` and `Unix & Linux`):
	#### https://grantm.github.io/perl-libxml-by-example/
use XML::LibXML; 


my $doc = XML::LibXML::Document->new('1.0', 'utf-8'); # https://metacpan.org/pod/distribution/XML-LibXML/lib/XML/LibXML/Document.pod
my $root = $doc->createElement("Proteins");

foreach my $uniprot (keys %proteins) {
	my $uniprot_tag = $doc->createElement('UniProt');
	$uniprot_tag->setAttribute('id' => $uniprot);
	$root->appendChild($uniprot_tag);
	
	## https://perldoc.perl.org/functions/keys.html hash of hashes
	foreach my $pdb (keys %{ $proteins{$uniprot} }) {
		my $pdb_tag = $doc->createElement('PDB');
		$pdb_tag->setAttribute('id' => $pdb);
		$uniprot_tag->appendChild($pdb_tag);
		
		if ($proteins{$uniprot}{$pdb}{'property'}) {
			
			## Each property has/will an **ARRAY** of ordered hashes
			foreach my $prop (@{ $proteins{$uniprot}{$pdb}{'property'} }) {
				my $prop_tag = $doc->createElement('property');
				$pdb_tag->appendChild($prop_tag);
				
				## for each property entry there is N attributes of that property
				## Ordered Hash requires iterator, same as Java :). https://metacpan.org/pod/Hash::Ordered#iterator
				my $iter = $prop->iterator;
				## add attributes in order to property tag, i.e. <property type="method" value="X-ray"/>
				while ( my ($key, $value) = $iter->() ) {
					$prop_tag->setAttribute($key => $value);
				}
			}
		}
	}
}

	

$doc->setDocumentElement($root);

## this way to print won't format. see toFile below
#print $doc->toString();
## this way to save won't formate see toFile below
#open my $out, '>', 'uniprot_pdb_out.xml';
#binmode $out;
#$doc->toFH($out);

$doc->toFile('uniprot_pdb_out.xml', 1); # see toFile() https://metacpan.org/pod/distribution/XML-LibXML/lib/XML/LibXML/Document.pod



