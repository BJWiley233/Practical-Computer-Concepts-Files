#! /usr/bin/perl

use strict;
use warnings;
use JSON;
use File::Slurp;
use XML::Simple;

## Gets file at ones into string
my $entire_file = read_file("../mod02_example_files/sc_response.txt");

my $decoded_json = decode_json $entire_file;
print "Status: " . $decoded_json->{status} . "\n";

#my %hash = %$decoded_json;
#print "Status: " . %$decoded_json{status} . "\n";


print "# Hits: " . $decoded_json->{data}->{results}->{total_hits} . "\n";


my %structures = %{$decoded_json->{data}->{results}->{structures}};
foreach my $key (keys %structures) {
	#print "Structure key $key: mol wt: " . $structures{$key}->{mol_weight} .
	#    " smiles: " . $structures{$key}->{smiles} . "\n";
	#print "Structure key $key: $structures{$key}\n";
}


my $json = encode_json \%structures;
#print "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n";
#print XMLout(\%structures);
#print "\n";
print "$json\n";

my $VAR1 = {
    'Eukaryota' => {
        'Rhodophyta'         => {'count' => 5},
        'Alveolata'          => {'count' => 16},
        'stramenopiles'      => {'count' => 57},
        'count'              => 155,
        'Glaucocystophyceae' => {'count' => 1},
        'Cryptophyta'        => {'count' => 18},
        'Malawimonadidae'    => {'count' => 1},
        'Viridiplantae'      => {'count' => 57},
    },
    'Bacteria' => {
        'Cyanobacteria'       => {'count' => 1},
        'Actinobacteria'      => {'count' => 4},
        'count'               => 33,
        'Proteobacteria'      => {'count' => 25},
        'Deinococcus-Thermus' => {'count' => 2},
        'Firmicutes'          => {'count' => 1},
    },
};

#analyse_contig_tree_recursively($decoded_json);

sub analyse_contig_tree_recursively {
    my $TAXA_TREE           =   shift @_;
    foreach my $k ( keys %{$TAXA_TREE} ) {
        print "$k \n";
        if (ref $TAXA_TREE->{$k} eq 'HASH') {
            analyse_contig_tree_recursively($TAXA_TREE->{$k});
        }
    }
}

