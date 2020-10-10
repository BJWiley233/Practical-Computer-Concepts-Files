#! /usr/bin/perl

=comment
Script 2 (50 pts)
Just using XML::Simple since only reading XML
=cut

use strict;
use warnings;
use LWP::UserAgent;
use XML::Simple;
use DBI;

my $xml = XML::Simple->new;

my $data = $xml->XMLin("Q04631.xml",
					         ForceArray=>[qw(dbReference)],
					         KeyAttr=>[]);
my $entry_node = $data->{entry};

## data needed
my $name;
my $fullname;  ## recommendedName TEXT for table 1
my $organism;  ## additional to requirements
my $taxid; 	   ## additional to requirements
my %pdbs;      ## making hash for pdb:method key/value pair
my %goids;     ## making hash for goid:term key/value pair
my $chainID; 	## the chain of PDB for the UniProtID alignment

my $dbref = $entry_node->{dbReference};

if (defined($dbref)) {
	foreach my $val (@$dbref) {
		if ( $val->{type} && ($val->{type} eq 'PDB') && ($val->{id}) ) {
			## We have PDB entries
			my $property = $val->{property};
			if (defined($property)) {
				foreach my $prop (@$property) {
					## Check if X-ray (no examples have 'NMR' but some have 'Model')
					if ($prop->{type} eq 'method' && $prop->{value} eq 'X-ray') {
						$pdbs{$val->{id}} = 'X-ray';							
					} elsif ($prop->{type} eq 'chains') {
						my $chains =  $prop->{value} =~ s/=.*//r;
						print $val->{id} . ": chain " . $prop->{value} . "\n";
						print "$chains\n";
					}	
				}
			}
		} elsif ( $val->{type} && ($val->{type} eq 'GO') && ($val->{id}) ) {
			my $property = $val->{property};
			if (defined($property)) {
				foreach my $prop (@$property) {
					## Only doing 1 property for now (method of determination).  Edit below here for more properties
					if ($prop->{type} eq 'term' && $prop->{value}) {
						$goids{$val->{id}} = $prop->{value};
						last;								
					}
				}
			}
		}
	}
}
