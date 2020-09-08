#! /usr/bin/perl

use strict;
use warnings;

my $raw_input = q(ABC, 350, An Org 
DEF, 500, DEF Org
GHI, 1000, Last Org);

## array to push hash tables to
my @genes;

## split the input by line
my @lines = split /\n/, $raw_input;

## loop through each line of data
foreach my $gene (@lines) {
	# split the CSV entry; easier with CSV library
	# see "part_e_additional.pl"
	my @entries = split ",", $gene;
	foreach my $entry (@entries) {
		trim(\$entry);
	}
	my %gene_hash = gene_inputs(\@entries);
	push(@genes, \%gene_hash);
}
	
foreach my $gene (@genes) {
	print "----\n";
	while (my ($key, $value) = each(%$gene)) {
		print $key . " => " . $value . "\n";
	}
}
	

sub gene_inputs {
	
	my $aref = $_[0];
	
	my $gene = $aref->[0];
	my $num_base_pairs = $aref->[1];
	my $organism = $aref->[2];
	
	my %hash = ("gene" => $gene,
		        "organism" => $organism,
		        "num_base_pairs" => $num_base_pairs);
	
	return %hash;
}

## for trimmming
## see https://perlmaven.com/trim
sub trim {
	my $string = shift;
	## regex substitution with g modifier
	## need to dereference, I like to use '{}' for dereference
	${$string} =~ s/^\s+|\s+$//g; 

}
		        
	
