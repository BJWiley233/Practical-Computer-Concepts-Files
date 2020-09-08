use JSON;
use File::Slurp;
use Data::Dumper;
use strict;
use warnings;

# Gets the whole file all at once (here into a string)
my $entire_file = read_file("sc_response.txt");

my $decoded_json = decode_json($entire_file);

#print Dumper($decoded_json);

print "Status: " .$decoded_json->{status} . "\n";
print "# Hits: " . $decoded_json->{data}->{results}->{total_hits} . "\n";

my $structures_node = $decoded_json->{data}->{results}->{structures};
while (my ($key, $value) = each(%$structures_node)) {
  print "Structure key $key: ";
  print "mol wgt: " . $value->{mol_weight} . " ";
  print "log_p: " . $value->{log_p} . "\n";
}