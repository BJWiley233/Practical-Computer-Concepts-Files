#! /usr/bin/perl

use DBI;
use List::MoreUtils qw(each_array); ## if you want for arrays like in stackoverflow ex.
strict;
warnings;

my $dbfile = "database1.db";
my $dbconnect = DBI->connect("dbi:SQLite:dbname=$dbfile");


$dbconnect->do("DROP TABLE IF EXISTS PDB;") or die $dbconnect->errstr;

$dbconnect->do("
	CREATE TABLE IF NOT EXISTS PDB (
		PDBId PRIMARY KEY, 
		method
	);
") or die $dbconnect->errstr;

# values
my %pdbs = ('3FMN' => 'X-ray',
		    '2LTY'=> 'NMR');

# prepare the INSERT statement once
my $nth_insert = $dbconnect->prepare('INSERT INTO PDB VALUES (?,?)');

# iterate over key: values
while ( my ($key, $value) = each %pdbs) {
	$nth_insert->execute($key, $value) or die $dbconnect->errstr;
}


