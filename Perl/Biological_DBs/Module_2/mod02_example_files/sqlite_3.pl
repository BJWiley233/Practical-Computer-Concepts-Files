use DBI;
use strict;

my $dbfile = "database3.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile");

my $table = 'test';
my @rows = qw(id time data);
my $sql_cmd = "create table $table(" .join(',', @rows) . ")";
print "sql command: $sql_cmd\n";
# Can only do a create once without an error
$dbh->do($sql_cmd) or die $DBI::errstr;

my @values = ("'12345'", "'21:08:57'");
push(@values, "'Here is some data'");
$sql_cmd = "insert into $table values (" . join(',', @values) . ")";
print "sql command: $sql_cmd\n";
$dbh->do($sql_cmd) or die $DBI::errstr;

