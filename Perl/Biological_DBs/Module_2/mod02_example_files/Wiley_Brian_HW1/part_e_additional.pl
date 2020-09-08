#! /usr/bin/perl

use strict;
use warnings;
use Text::CSV; # https://metacpan.org/pod/Text::CSV

=comment
This script requires input file input_part_e.csv
Feel free to post this code for class.
=cut

## array to push hash tables to
my @genes;

## read in data
my @rows;
my $csv = Text::CSV->new;
open my $fh, "<:encoding(utf8)", "input_part_e.csv" or die "can't find file";

while (my $row = $csv->getline ($fh)) {
	## need to put '@$' to make array
	if ( (scalar @$row) == 3) {
		push(@rows, $row);
	}
}

## loop through each row of data
foreach my $gene (@rows) {
	## $gene is already an array reference
	## see "...parses this row into an array ref" at https://metacpan.org/pod/Text::CSV#getline
	my %gene_hash = gene_inputs($gene);
	push(@genes, \%gene_hash);
}
	
foreach my $gene (@genes) {
	print "----\n";
	## since only 3 entries in hash can print to maintain order
	print "gene => " . $gene->{gene} . "\n";
	print "organism => " . $gene->{organism} . "\n"; 
	print "num_base_pairs => " . $gene->{num_base_pairs} . "\n"; 
	#while (my ($key, $value) = each(%$gene)) {
	#	print $key . " => " . $value . "\n";
	#}
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
