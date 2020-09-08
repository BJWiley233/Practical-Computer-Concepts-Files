use DBI;
use strict;
use warnings;

my $dbfile = "database2.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile");

# Create a table PDB with two columns:
$dbh->do("create table PDB (PDBId, method)") or die $DBI::errstr;
# Insert some values
$dbh->do("insert into PDB values ('3FMN', 'X-Ray')");
$dbh->do("insert into PDB values ('2LTY', 'NMR')");

# Show example using variables
my $table = 'test';
my @rows = qw(id pdb data); # qw will make these items strings
my $sql_cmd = "create table $table(" .join(',', @rows) . ")";
print "sql command: $sql_cmd\n";
$dbh->do($sql_cmd) or die $DBI::errstr;

my @values = ("'Q16539'", "'3FMN'");
push(@values, "'Here is some data'");
$sql_cmd = "insert into $table values (" . join(',', @values) . ")";
print "sql command: $sql_cmd\n";
$dbh->do($sql_cmd) or die $DBI::errstr;

my $res = $dbh->selectall_arrayref( 
   "SELECT a.id, a.pdb, b.method FROM PDB b, test a WHERE a.pdb = b.PDBId");

foreach my $row (@$res) {
  print join(" ", @$row);
  print "\n";
}


$dbh->disconnect;