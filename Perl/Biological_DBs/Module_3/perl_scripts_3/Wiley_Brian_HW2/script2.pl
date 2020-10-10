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
#use List::MoreUtils qw(each_array); ## https://stackoverflow.com/questions/12528913/how-can-i-insert-data-from-three-perl-arrays-into-a-single-mysql-table


## Open file with filehandle in
open(FHin, "<:encoding(utf8)", "HW2_2.txt") or die $!;

## set UserAgent
my $ua = LWP::UserAgent->new;

## create tables at beginning
my $dbfile = "script2.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile");

## table 1
$dbh->do("DROP TABLE IF EXISTS UniProt;") or die $dbh->errstr;
$dbh->do("
	CREATE TABLE IF NOT EXISTS UniProt (
		UniProtID CHAR(15) PRIMARY KEY UNIQUE, 
		name TEXT NOT NULL,
		recommendedName TEXT,
		organism TEXT NOT NULL,
		taxid INT NOT NULL
	);"
) or die $dbh->errstr;

## table 2
$dbh->do("DROP TABLE IF EXISTS Structures;") or die $dbh->errstr;
$dbh->do("
	CREATE TABLE IF NOT EXISTS Structures (
		PDBID CHAR (5) PRIMARY KEY UNIQUE,
		UniProtID CHAR(15) NOT NULL, 
		method TEXT NOT NULL,
		CONSTRAINT fk_UniProt
			FOREIGN KEY(UniProtID) REFERENCES UniProt(UniProtID)
	);"
) or die $dbh->errstr;

## table 3
$dbh->do("DROP TABLE IF EXISTS Go;") or die $dbh->errstr;
$dbh->do("
	CREATE TABLE IF NOT EXISTS Go (
		GOID CHAR (15) PRIMARY KEY UNIQUE,
		UniProtID CHAR(15) NOT NULL,
		term TEXT,
		CONSTRAINT fk_UniProt
			FOREIGN KEY(UniProtID) REFERENCES UniProt(UniProtID)
	);"
) or die $dbh->errstr;

## prepare entries for table 1 before entering loop
## stackoverflow indicates best to use the (?) placeholders
## since entries may be more than one word with spaces
my $uniprot_insert = $dbh->prepare('INSERT INTO UniProt VALUES (?,?,?,?,?)');

## for each line in FHin (HW2_2.txt)
while (<FHin>) {
	chomp $_;
	
	## get UniProt ID after 'Uniprot:' using s replace
	$_ =~ s/.*://;
	## trim white space
	trim(\$_);
	
	if ($_ =~ /^[a-zA-Z](\d+){5}/) {
		print "Processing $_ ...\n";
		
		my $response = $ua->get("https://www.uniprot.org/uniprot/$_.xml",
					'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
		unless ($response->is_success) {
			die "https status: " . $response->code . "\n";
			    "Failed, got " . $response->status_line .
			    " for " . $response->request->uri . "\n";
		}
		
		
		my $xml = XML::Simple->new;
		my $data = $xml->XMLin($response->content,
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
			## should always have one; therefore making NOT NULL in db
			## might eventually catch Uniprot entry without it and can email UniProt
			if ($entry_node->{organism}->{dbReference}) {
				foreach my $entry (@{ $entry_node->{organism}->{dbReference} }) {
					if ($entry->{type} =~ 'NCBI Taxonomy') {
						$taxid = $entry->{id};
					}
				}
			} else {
				warn "There is not a taxonomy reference for $_. " .
					 "May want to email UniProt about it.";
			}

			## get PDBs and if method = 'X-ray' store in PDBID:method hash
			## loop also which check if else db reference is GO and also
			## saves in a GOID:term hash
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
			my $uniprot_insert = $dbh->prepare('INSERT INTO UniProt VALUES (?,?,?,?,?)');
			$uniprot_insert->execute($_, $name, $fullname, $organism, $taxid)
				or die $dbh->errstr;
			
			## insert data into table 2 - Structures table
			my $pdb_insert = $dbh->prepare('INSERT INTO Structures VALUES (?,?,?)');
			while ( my ($pdb_key, $pdb_value) = each %pdbs ) {
				$pdb_insert->execute($pdb_key, $_, $pdb_value)
					or die $dbh->errstr;
			}
			
			## insert data into table 3 - Go table
			my $go_insert = $dbh->prepare('INSERT OR IGNORE INTO Go VALUES (?,?,?)');
			while ( my ($go_key, $go_value) = each %goids ) {
				$go_insert->execute($go_key, $_, $go_value)
					or die $dbh->errstr;
			}
		}		
	} else {
		## print error
		print STDERR "ERROR! UniProt ID $_ is not a valid id\n";
	}
}

################################
## Print some data
################################

## get list of tables
my $sql = "SELECT name FROM sqlite_master WHERE type='table'";
my $tables = $dbh->selectcol_arrayref($sql);

## get count from each table and print
foreach my $table (@$tables) {
	my $prep = $dbh->prepare("SELECT COUNT(*) FROM $table");
	$prep->execute;
	my $length = $prep->fetchrow_arrayref->[0];
	print "$length entries were added to the $table table.\n";
}

## print out 5 random entries from each table
print "\nHere are 5 random rows from each table:\n\n";

foreach my $table (@$tables) {
	print "'$table' table:\n";
	my $result = $dbh->prepare("SELECT * FROM $table
							    ORDER BY RANDOM() LIMIT 5"
	);		
	$result->execute;
	
	## https://stackoverflow.com/questions/2283065/how-can-i-get-column-names-and-row-data-in-order-with-dbi-in-perl
	my $fields = $result->{NAME_lc};
	
	## numbler of columns in each table
	my $ncol = scalar(@$fields);
	
	## set the formatting, easy only if very few columns
	my $width_string = '';
	for (my $i = 0; $i < 2; $i++) {
		$width_string .= "%-15s"
	}
	$width_string .= "%-43s";
	for (my $i = 3; $i < $ncol; $i++) {
		$width_string .= "%-28s"
	}
	$width_string .= "\n";

	## print the columns names and row data
	printf($width_string, @$fields);
	while (my $row = $result->fetchrow_arrayref) {
		printf($width_string, @$row)
	}
	print "\n";
}
		

## for trimmming; from part_d/e in HW1
## see https://perlmaven.com/trim
sub trim {
	my $string = shift;
	## regex substitution with g modifier
	## need to dereference, I like to use '{}' for dereference
	${$string} =~ s/^\s+|\s+$//g; 

}
