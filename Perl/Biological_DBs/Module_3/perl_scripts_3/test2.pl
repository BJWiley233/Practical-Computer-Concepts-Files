#! /usr/bin/perl


use strict;
#use warnings;
use LWP::UserAgent;
use XML::Simple;
use DBI;
use List::MoreUtils qw(each_array); ## https://stackoverflow.com/questions/12528913/how-can-i-insert-data-from-three-perl-arrays-into-a-single-mysql-table
use Data::Dumper;

my $_id = "P29274";
my $ua = LWP::UserAgent->new;

## create tables at beginning
my $dbfile = "script2.db";
my $dbconnect = DBI->connect("dbi:SQLite:dbname=$dbfile");

## table 1
$dbconnect->do("DROP TABLE IF EXISTS UniProt;") or die $dbconnect->errstr;
$dbconnect->do("
	CREATE TABLE IF NOT EXISTS UniProt (
		UniProtID CHAR(15) PRIMARY KEY UNIQUE, 
		name TEXT NOT NULL,
		recommendedName TEXT,
		organism TEXT NOT NULL,
		taxid INT NOT NULL
	);
") or die $dbconnect->errstr;

## table 2
$dbconnect->do("DROP TABLE IF EXISTS Structures;") or die $dbconnect->errstr;
$dbconnect->do("
	CREATE TABLE IF NOT EXISTS Structures (
		PDBID CHAR (5) PRIMARY KEY UNIQUE,
		UniProtID CHAR(15) NOT NULL, 
		method TEXT NOT NULL,
		CONSTRAINT fk_UniProt
			FOREIGN KEY(UniProtID) REFERENCES UniProt(UniProtID)
	);
") or die $dbconnect->errstr;

## table 3
$dbconnect->do("DROP TABLE IF EXISTS Go;") or die $dbconnect->errstr;
$dbconnect->do("
	CREATE TABLE IF NOT EXISTS Go (
		GOID CHAR (15) PRIMARY KEY UNIQUE,
		UniProtID CHAR(15) NOT NULL,
		term TEXT,
		 CONSTRAINT fk_UniProt
			FOREIGN KEY(UniProtID) REFERENCES UniProt(UniProtID)
	);
") or die $dbconnect->errstr;

=comment
my $response = $ua->get("https://www.uniprot.org/uniprot/$_id.xml",
					'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
unless ($response->is_success) {
	die 
	"https status: " . $response->code . "\n";
	'Failed, got ' . $response->status_line .
	' for ' . $response->request->uri . "\n";
}
=cut
my $xml = XML::Simple->new;
#my $data = $xml->XMLin($response->content,
#				   ForceArray=>[qw(dbReference)],
#				   KeyAttr=>[]);
my $data = $xml->XMLin("$_id.xml",
					   ForceArray=>[qw(dbReference)],
					   KeyAttr=>[]);

#open (FHout, '>', "$_id.out");
#print FHout Dumper($data);

#my $xml = XML::Simple->new;
#my $data = $xml->XMLin("$_id.xml");
my $entry_node = $data->{entry};

## data needed
my $name;
my $fullname;  ## recommendedName TEXT for table 1
my $organism;
my $taxid;
my %pdbs;  ## making hash for pdb:method key/value pair
my %goids; ## making hash for goid:term key/value pair

if (defined($entry_node)) {
	$name = $entry_node->{name};
	$fullname = $entry_node->{protein}->{recommendedName}{fullName};
	
	## organism->name is an array need to loop for type="scientific"
	foreach my $name_entry (@{ $entry_node->{organism}->{name} }) {
		if ($name_entry->{type} eq 'scientific') {
			$organism = $name_entry->{content};
			last;
		}
	}

	## check if there is NCBI Taxonomy entry
	## should always have one; therefore making not null
	## migh eventually catch Uniprot entry without it and can email UniProt
	if ($entry_node->{organism}->{dbReference}) {
		foreach my $entry (@{ $entry_node->{organism}->{dbReference} }) {
			if ($entry->{type} =~ 'NCBI Taxonomy') {
				$taxid = $entry->{id};
			}
		}
	} else {
		warn "There is not a taxonomy reference for $_id. " .
			"May want to email UniProt about it.";
	}


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
							last;								
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
	
	## insert data into table 1	- UniProt table
	my $uniprot_insert = $dbconnect->prepare('INSERT INTO UniProt VALUES (?,?,?,?,?)');
	$uniprot_insert->execute($_id, $name, $fullname, $organism, $taxid)
		or die $dbconnect->errstr;
	
	## insert data into table 2 - Structures table
	my $pdb_insert = $dbconnect->prepare('INSERT INTO Structures VALUES (?,?,?)');
	while ( my ($pdb_key, $pdb_value) = each %pdbs ) {
		$pdb_insert->execute($pdb_key, $_id, $pdb_value)
			or die $dbconnect->errstr;
	}
	
	## insert data into table 3 - Go table
	my $go_insert = $dbconnect->prepare('INSERT INTO Go VALUES (?,?,?)');
	while ( my ($go_key, $go_value) = each %goids ) {
		$go_insert->execute($go_key, $_id, $go_value)
			or die $dbconnect->errstr;
	}
	
	

	
	print "name: $name\n";
	print "fullname: $fullname\n";
	print "organism: $organism\n";
	print "taxid: $taxid\n";

}
