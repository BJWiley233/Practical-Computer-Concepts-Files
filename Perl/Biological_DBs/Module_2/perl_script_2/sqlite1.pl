#! /usr/bin/perl

use DBI;
strict;
warnings;

my $dbfile = "database1.db";
my $dbconnect = DBI->connect("dbi:SQLite:dbname=$dbfile");

=comment
If you want to process multiple statements
$dbconnect->{sqlite_allow_multiple_statements} = 1;
$dbconnect->do("
	DROP TABLE IF EXISTS PDB;
	
	CREATE TABLE IF NOT EXISTS PDB (
		PDBId PRIMARY KEY, 
		method
	);
") or die $dbconnect->errstr;
=cut

## SQLite create table; https://sqlite.org/lang_createtable.html; https://www.sqlitetutorial.net/sqlite-create-table/
$dbconnect->do("DROP TABLE IF EXISTS PDB;") or die $dbconnect->errstr;

$dbconnect->do("
	CREATE TABLE IF NOT EXISTS PDB (
		PDBId PRIMARY KEY, 
		method
	);
") or die $dbconnect->errstr;

my %pdbs = ('3FMN' => 'X-ray',
		    '2LTY'=> 'NMR');

# prepare the INSERT statement once
my $nth_insert = $dbconnect->prepare('INSERT INTO PDB VALUES (?,?)');

# iterate over key: values
while ( my ($key, $value) = each %pdbs) {
	$nth_insert->execute($key, $value) or die $dbconnect->errstr;
}

=comment
## Insert values; https://sqlite.org/lang_insert.html; https://www.sqlitetutorial.net/sqlite-insert/
$dbconnect->do(q{
	INSERT INTO PDB 
	VALUES 
		('3FMN', 'X-ray'),
		('2LTY', 'NMR')
}) or die $dbconnect->errstr;
=cut

