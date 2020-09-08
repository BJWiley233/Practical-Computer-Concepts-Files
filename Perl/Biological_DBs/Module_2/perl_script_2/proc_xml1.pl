#! /usr/bin/perl

use LWP::Simple;
use XML::Simple qw(:strict);
use Data::Dumper;
use strict;
#use warnings;
use XML::Writer;



my @uniprot_id = ("Q16539");
#my $filename = "proc_xml1.txt";
my $filename = "proc_xml1.xml";
my $url = "https://www.uniprot.org/uniprot/$uniprot_id[0].xml";
my $agent = LWP::UserAgent->new;
my $xml = XML::Simple->new;



#my $response = $agent->get($url,
#	'UA' => 'Mozilla/4.0 (compatible; MSIE 7.0)');




=comment

if ($response->is_success) {
	#print 'Content type is ' . $response->content_type . "\n";
	
	if ($response->content_type eq "application/xml") {
		#print "Process an XML response\n";
		#print $response->content;
		my $xml = XML::Simple->new;
		#my $type = ref($xml);
		#print $type . "\n";
		$data = $xml->XMLin($response->content);
		#print Dumper($data);
		open(FH, '>', $filename) or die $!;
		print FH $response->content;
	}
} else {
	die 'Failed, got ' . $response->status_line .
    ' for ' . $response->request->uri . "\n";
 }
 
=cut

my $data; 
#$data = $xml->XMLin($filename);

$data = $xml->XMLin($filename,
					ForceArray=>[qw(dbReference)],
					KeyAttr=>[]
					);
#open(FH, '>', 'proc_xml1.txt') or die $!;
#print FH Dumper($data);
my $entry_node = $data->{entry};


=item stuff()

 This function does stuff.
 
=cut

sub stuff {
	$_[0] = 1;
    $_[1] = 2;
}

=pod

Remember to check its return value, as in:

  stuff() || die "Couldn't do stuff!";
  
=cut

=comment
if (defined($entry_node)) {
	while (my ($key, $value) = each(%$entry_node)) {
		print "$key gives $value\n";
	}
}
=cut

## get $entry_node->accession, i.e. $entry_node->$acc_node
=comment
my $acc_node = $entry_node->{accession};
if (defined($acc_node)) {
	foreach my $val (@$acc_node) {
		print "Accession: $val\n";
	}
}
print $acc_node . "\n\n";
=cut
=comment
my $dbref = $entry_node->{dbReference};
if (defined($dbref)) {
	while (my ($key, $value) = each(%$dbref)) {
		if ($key eq 'CR536505' || $key =~ '1WBO|3RIN') {
			while (my ($subkey, $subvalue) = each(%$value)) {
					print "$key has subkey $subkey = $subvalue\n";
				}
		}
	}
}
=cut
my @all_pdbs;
my @my_xray_pdbs;
my @my_nmr_pdbs;

my %proteins;
proteins{$uniprot_id[0]} =  

my $dbref = $entry_node->{dbReference};
if (defined($dbref)) {
	foreach my $val (@$dbref) {
		if ($val->{type} && ($val->{type} eq 'PDB') && ($val->{id})) {
			#print "DB ref " . $val->{id} . " is a PDB id\n";
			push(@all_pdbs, $val->{id});
			my $property = $val->{property};
			if (defined($property)) {
				foreach my $prop (@$property) {
					if ($prop->{value} eq 'X-ray') {
						#print "pushing x-ray\n";
						push(@my_xray_pdbs, $val->{id})
					}
					if ($prop->{value} eq 'NMR') {
						#print "pushing nmr\n";
						push(@my_nmr_pdbs, $val->{id})
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

print scalar(@all_pdbs) . "\n";
print scalar(@my_xray_pdbs) . "\n";
print scalar(@my_nmr_pdbs) . "\n";


if (length(@all_pdbs) > 0) {
	#my %my_xml = ("UniProt" => $uniprot_id,
	#			  "PDB" => \@all_pdbs); 		# References array
	#my $out_xml = XML::Simple->new(NoAttr=>1, RootName=>'Proteins');
	#my $out_data = $out_xml->XMLout(\%my_xml);
	#print "$out_data\n";
	my %my_xml = ("UniProt" => $uniprot_id,
                  "PDB" => \@all_pdbs);
    my $out_xml = new XML::Simple(NoAttr=>1, RootName=>'Proteins');
    my $out_data = $out_xml->XMLout(\%my_xml, KeyAttr=>[]);
    print "$out_data\n";
  
}

use XML::LibXML;



my $doc = $XML::LibXML::Document->new('1.0', 'utf-8');
my $root = $doc->createElement("Proteins");


