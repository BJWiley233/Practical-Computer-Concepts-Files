#! /usr/bin/perl

use Bio::DB::GenBank;
use Bio::SeqIO;
use Bio::DB::EUtilities;


my $factory = Bio::DB::EUtilities->new(-eutil   => 'efetch',
									   -email   => 'bwiley4@jh.edu',
									   -db      => 'nuccore',
									   -id      => '1068937310',
									   -rettype => 'gb');

my $gb_response = $factory->get_Response();

#print $gb_response . "\n";
#for my $key (keys %$gb_response) {
#	print $key . "\n";
#}
#print $gb_response->{_content} . "\n";

my @features = Bio::SeqIO->new(-string => $gb_response->{_content})->next_seq->get_SeqFeatures;
	
print $features . "\n";
foreach my $feat_object (@features) {
	print $feat_object . "\n";
}
									
## don't want to download file
#my $seqio_object = Bio::SeqIO->new(-file => "BAB55667.gb" );
