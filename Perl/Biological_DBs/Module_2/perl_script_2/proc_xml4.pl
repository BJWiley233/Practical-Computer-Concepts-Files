#! /usr/bin/perl

use LWP::Simple;
use XML::Simple qw(:strict);
use Data::Dumper;
use strict;

use XML::Writer;



my @uniprot_ids = ("Q16539");

#my $filename = "proc_xml1.txt";
my $filename = "proc_xml1.xml";
# foreach $uniprot_id (@uniprot_ids) {
	#my $url = "https://www.uniprot.org/uniprot/$uniprot_id.xml";
#}
#my $url = "https://www.uniprot.org/uniprot/$uniprot_ids[0].xml";
#my $agent = LWP::UserAgent->new;
#my $response = $agent->get($url,
#	'UA' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
my $xml = XML::Simple->new;


my $data; 

## instead of $filename that I wrote earlier
## this would be ->XMLin($response->content, ...
$data = $xml->XMLin($filename,
					ForceArray=>[qw(dbReference)],
					KeyAttr=>[]);



## used for testing earlier
my @all_pdbs;
my @my_xray_pdbs;
my @my_nmr_pdbs;

## this would store list of UniProts which PDB IDs as children that each have properties
my %proteins;

my $entry_node = $data->{entry};
my $dbref = $entry_node->{dbReference};
if (defined($dbref)) {
	$proteins{$uniprot_ids[0]} =  {};
	foreach my $val (@$dbref) {
		if ($val->{type} && ($val->{type} eq 'PDB') && ($val->{id})) {
			#print "DB ref " . $val->{id} . " is a PDB id\n";
			push(@all_pdbs, $val->{id});
			$proteins{$uniprot_ids[0]}{$val->{id}} = {};
			my $property = $val->{property};
			if (defined($property)) {
				foreach my $prop (@$property) {
					if ($prop->{value} eq 'X-ray') {
						#print "pushing x-ray\n";
						my %my_prop = ("type", "method",
						               "value", "X-ray");
						$proteins{$uniprot_ids[0]}{$val->{id}}{'property'} = [\%my_prop]; 
						push(@my_xray_pdbs, $val->{id})
						
					}
					if ($prop->{value} eq 'NMR') {
						#print "pushing nmr\n";
						push(@my_nmr_pdbs, $val->{id});
						my %my_prop = ("type", "method",
						               "value", "NMR");
						$proteins{$uniprot_ids[0]}{$val->{id}}{'property'} = [\%my_prop];
					}
				}
			}			
		} else {
			#print "Type not PDB for " . $val->{id} . " Type is " . $val->{type} . "\n";
		}
	}
} else {
	print "No dbRef\n";
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
## just printing to confirm structure of stored data from XML::Simple:;XMLin
print $proteins{$uniprot_ids[0]}{'3C5U'}{'property'}[0]{'type'} . "\n";
print $proteins{$uniprot_ids[0]}{'3C5U'}{'property'}[0]{'value'} . "\n";

## this tutorial helped http://www.streppone.it/cosimo/blog/2010/05/how-to-generate-an-xml-document-with-xmllibxml/
## so is this one (Grant is a great resource.  Very active on `Stackoverflow` and `Unix & Linux`:
	### https://grantm.github.io/perl-libxml-by-example/
use XML::LibXML;

my $doc = XML::LibXML::Document->new('1.0', 'utf-8');
my $root = $doc->createElement("Proteins");

#https://perldoc.perl.org/functions/keys.html
foreach my $uniprot (keys %proteins) {
	my $uniprot_tag = $doc->createElement('UniProt');
	$uniprot_tag->setAttribute('id' => $uniprot);
	$root->appendChild($uniprot_tag);
	foreach my $pdb (keys %{$proteins{$uniprot}}) {
		my $pdb_tag = $doc->createElement('PDB');
		$pdb_tag->setAttribute('id' => $pdb);
		$uniprot_tag->appendChild($pdb_tag);
		if ($proteins{$uniprot}{$pdb}{'property'}) {
			#print "PDB has a property\n";  ## print for checking
			## Each property has an **ARRAY** of hashes
			foreach my $prop (@{ $proteins{$uniprot}{$pdb}{'property'} }) {
				#print $prop . "\n";
				my $prop_tag = $doc->createElement('property');
				$pdb_tag->appendChild($prop_tag);
				## for each property entry there is N attributes of that property
				foreach my $key (keys %$prop) {
					if ($key eq "type") {
						#print "Key = $key, Value = " . %$prop{$key} . "\n";
					}
					#my $value = %$prop{$key};
					## Why this line below doesn't work?!?!
					$prop_tag->setAttribute($key =>$prop->{$key});
					#$prop_tag->setAttribute($key => $value);
				}
			}
		}
	}
}

	

$doc->setDocumentElement($root);
#print $doc->toString();
## save
#open my $out, '>', 'uniprot_pdb_out.xml';
#binmode $out;
#$doc->toFH($out);
$doc->toFile('uniprot_pdb_out4.xml', 1);



