use DBI;
use strict;
use warnings;

my $dbfile = "database1.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile");

# Create a table PDB with two columns:
$dbh->do("create table PDB (PDBId, method)") or die $DBI::errstr;
# Insert some values
$dbh->do("insert into PDB values ('3FMN', 'X-Ray')");
$dbh->do("insert into PDB values ('2LTY', 'NMR')");

# Get all the rows. Uppercase SQL commands are OK, too.
my $all_rows = $dbh->selectall_arrayref("SELECT * FROM PDB");

foreach my $row (@$all_rows) {
  # Row is an array reference.
  # Notice getting the information from the array into individual variables:
  my ($id, $method) = @$row;
  print "$id|$method\n";
}

$dbh->disconnect;