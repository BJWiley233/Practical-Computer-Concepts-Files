#! /usr/bin/perl

use strict;
use warnings;

use XML::Simple;
use Bio::DB::EUtilities;
use Bio::SeqIO;

my $pkCounter = 1;

my $giId = '1068937310';
#$id = '577019525';

my $factory = Bio::DB::EUtilities->new(-eutil   => 'efetch',
									   -email   => 'bwiley4@jh.edu',
									   -db      => 'nuccore',
									   -id      => $giId,
									   -rettype => 'gb');


my $gb_response = $factory->get_Response;
my $seq_object = Bio::SeqIO->new(-string => $gb_response->{_content})->next_seq;

my $accessionID;
if ( defined($seq_object->accession_number) && 
     defined(%$seq_object{_seq_version}) ) {
	$accessionID = $seq_object->accession_number . "." . 
		%$seq_object{_seq_version} .  "\n";
}

my @giIdArray; # hold array of arrays that are NFeatures x 20/21 if taxon

my @seqFeatures = $seq_object->get_SeqFeatures; #Get the array of features https://metacpan.org/pod/Bio::SeqFeature::Generic#get_SeqFeatures

my $organism;
my $mol_type;
my $taxon = 0; ## have to check source for taxon since might be different if not passed to main program
my $chromosom;
my $map;

foreach my $feat_object (@seqFeatures) {
	my @feature; # array of length 20 or 21 if taxon in source
	
	if ($taxon == 0) {
	## we should only do this if taxon is not passed to main program this is a waste if so
		if ($feat_object->primary_tag eq "source") {
			if ( $feat_object->has_tag('db_xref') ) {
				# https://metacpan.org/pod/Bio::SeqFeature::Generic#get_tag_values
				my @values = $feat_object->get_tag_values('db_xref');
				print $values[0] . "\n";
			}
		}
	} else {
		#taxon = $taxon
	}
	if ($feat_object->primary_tag eq "CDS") {
		
		print "primary tag: ", $feat_object->primary_tag, "\n";
=comment
		foreach my $tag ($feat_object->get_all_tags) {
			print "  tag: ", $tag, "\n";
			for my $value ($feat_object->get_tag_values($tag)) {
				print "    value: ", $value, "\n";
			}
		}
=cut
	}
}
=cut

=comment
while ( my ($key, $value) = each (%$seq_object) ) {
	print "key: $key, value: $value\n";
}
=cut
