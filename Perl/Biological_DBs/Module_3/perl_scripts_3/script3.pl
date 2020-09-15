#! /usr/bin/perl

=comment
Script 3 (50 pts)

Case matters for entry, letters must be uppercase
Entry '5TVN' without quotes returns data
Entry 'BBBB' without quotes does not return data
=cut

use strict;
use warnings;
use DBI;

my $dbfile = "script2.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile");

print "Enter a PDBID:\n";
my $entry = <STDIN>;
chomp $entry;

## prepare select statement for pdb ID
my $up_result = $dbh->prepare("SELECT u.UniProtID, u.name, s.PDBID
							   FROM Structures s
								    INNER JOIN UniProt u ON s.UniProtID = u.UniProtID
							   WHERE s.PDBID = (?)"
) or die $dbh->errstr;
## execute with entry
$up_result->execute($entry);

## get results, using fetchall if more than 1 uniprot entry
my $up_data = $up_result->fetchall_arrayref;

## if no results print warning
## else if single result print info and GOID:term pairs
## if more than 1 entry just warn and proceed with first
if (scalar(@$up_data) == 0) {
	warn "PDB ID is not in database.\n"
} elsif (scalar(@$up_data) == 1) {
	print "UniProtID => " . $up_data->[0][0] . "\n";
	print "Name => " . $up_data->[0][1] . "\n";
	my $uid = $up_data->[0][0];
	
	my $go_result = $dbh->prepare("SELECT g.GOID, g.term, u.UniProtID
							       FROM UniProt u
								        INNER JOIN GO g ON u.UniProtID = g.UniProtID
							       WHERE u.UniProtID = (?)"
	) or die $dbh->errstr;
	$go_result->execute($uid);
	
	my $go_data = $go_result->fetchall_arrayref;
	print "Here are a list of GOID:term pairs for your UniProtID\n";
	printf("%-15s%-20s\n", "GOID", "term");
	
	foreach my $row (@$go_data) {
		printf("%-15s%-20s\n", $row->[0], $row->[1]);
	}
	
} else {
	warn "You have an interesting PDB ID that has more " .
	     "than 1 associated UniProt ID.  Here is first one:\n";
	print "UniProtID => " . $up_data->[0][0] . "\n";
	print "Name => " . $up_data->[0][1] . "\n";
	
	my $uid = $up_data->[0][0];
	
	my $go_result = $dbh->prepare("SELECT g.GOID, g.term, u.UniProtID
							       FROM UniProt u
								        INNER JOIN GO g ON u.UniProtID = g.UniProtID
							       WHERE u.UniProtID = '$uid'"
	) or die $dbh->errstr;
	$go_result->execute;
	
	my $go_data = $go_result->fetchall_arrayref;
	print "Here are a list of GOID:term pairs for your UniProtID\n";
	printf("%-15s%-20s\n", "GOID", "term");
	
	foreach my $row (@$go_data) {
		printf("%-15s%-20s\n", $row->[0], $row->[1]);
	}
}
