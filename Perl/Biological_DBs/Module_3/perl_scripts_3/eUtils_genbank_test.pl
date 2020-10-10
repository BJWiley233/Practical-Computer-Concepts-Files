#! /usr/bin/perl

use LWP::Simple;
use XML::Simple;
use Bio::DB::GenBank;
use Bio::SeqIO;
use Bio::DB::EUtilities;
use Getopt::Long;
use Pod::Usage; # https://perldoc.perl.org/Pod/Usage.html#AUTHOR
use Data::Dumper;
use XML::LibXML;

my $giId = '1956';
my $db = 'gene';
my $email = 'bwiley4@jh.edu';
my $refseq = 1; # default to not filter by refseq 
my $genomic = 0;

=comment
my $factory = Bio::DB::EUtilities->new(-eutil   => 'efetch',
									   -email   => $email,
									   -db      => 'gene',
									   -id      => $giId,
									   -rettype => 'xml');
#my $file = "egfr1.xml";
#$factory->get_Response(-file => $file);
my $gb_response = $factory->get_Response;

my $dom = XML::LibXML->load_xml(string => $gb_response->{_content});
=cut
my $dom = XML::LibXML->load_xml(location => 'egfr1.xml');

foreach my $commentary ($dom->findnodes('///Entrezgene/Entrezgene_locus/Gene-commentary')) {
	#print $commentary . "\n";
	#print $commentary->{Gene-commentary_label} . "\n";
	if (defined($commentary->findvalue('./Gene-commentary_label'))) {
	
	
		if ($refseq) {
			if ($commentary->findvalue('./Gene-commentary_label') =~ 'RefSeq') {
				$genomic = $commentary->findvalue('./Gene-commentary_accession');
				last;
			}
		} else { # no refseq parameter given by user
			if (!($commentary->findvalue('./Gene-commentary_label') =~ 'RefSeq')) {
				$genomic = $commentary->findvalue('./Gene-commentary_accession');
				last;
			}
		}
	}	
}
print $genomic . "\n";

if ($genomic) {
	my $factory = Bio::DB::EUtilities->new(-eutil   => 'efetch',
									       -email   => $email,
										   -db      => 'nuccore',
										   -id      => $genomic,
										   -rettype => 'gb');


	my $gb_response = $factory->get_Response;

	if (defined($gb_response->{_content})) {
		open(FH, '>', 'egfr1.gb');
		print FH Dumper($gb_response->{_content});
		my $seq = Bio::SeqIO->new(-string => $gb_response->{_content})->next_seq;
			
		## get all features
		my @features = $seq->get_SeqFeatures;
		
		## see these links for what you can do with the @features and the tags
		## https://stackoverflow.com/questions/22073986/how-do-i-get-gene-features-in-fasta-nucleotide-format-from-ncbi-using-perl
		## https://bioperl.org/howtos/Features_and_Annotations_HOWTO.html
		
		## get single type of features
		my @source_features = grep { $_->primary_tag eq 'source' } 
						  $seq->get_SeqFeatures;
		
		print ${\($source_features[0]->get_tag_values('organism'))} . "\n";
		print ${\($source_features[0]->get_tag_values('mol_type'))} . "\n\n";

		my @gene_features = grep { $_->primary_tag eq 'gene' } 
						$seq->get_SeqFeatures;
						
		## Example only exons
		my @exon_features = grep { $_->primary_tag eq 'exon' } 
						$seq->get_SeqFeatures;   
						
		for my $source_object (@source_features) {
			for my $tag ($source_object->get_all_tags) {
				print "$tag= ";
				for my $value ($source_object->get_tag_values($tag)) {
					print "$value, ";
				}
				print "\n";
			}
		}
		
			
		
		## get accession and source feature data
		## stinks that get_tag_values doesn't return a reference to
		## the arrays. see https://metacpan.org/pod/Bio::SeqFeature::Generic#get_tag_values
		my $accessionId = $seq->accession_number . "." . $seq->{_seq_version};
		my $moltype;
		eval {
			$moltype = ${\($source_features[0]->get_tag_values('mol_type'))};
			1;
		} or do {
			my $error = $@ || 'Tag does not exist';
			warn "** Warning: Could not find mol_type tag under source";
		};
		my $chromosome = ${\($source_features[0]->get_tag_values('chromosome'))};
		my $map = ${\($source_features[0]->get_tag_values('map'))};
		my $organism = ${\($source_features[0]->get_tag_values('organism'))};

		################################################################
		#Alternatively you could get the Source feature data like in the 
		#BioPerl HowTo
		################################################################
				
		print "Here are the exons for\n". 
		   "   GI: $giId\n". 
		   "   Accession: $accessionId\n". 
		   "   Organism: $organism\n".
		   "   Chromosome: $chromosome\n". 
		   "   Location: $map\n".
		   "   Mol Type: $moltype\n\n";
=comment
		for my $exon_object (@exon_features) {
			print "> " . $seq->accession_number . "." . $seq->{_seq_version} .
				"|" . $exon_object->primary_tag;
			if ($exon_object->has_tag("gene")) {
				my @genes = $exon_object->get_tag_values('gene');
				print "|gene=" . $genes[0];
			} 
			print "|" . $exon_object->start . ".." . $exon_object->end . "\n";
			
			print $exon_object->spliced_seq->seq . "\n";
		}
=cut
	}
}
				

=comment

my @source_features = grep { $_->primary_tag eq 'source' } 
                      $seq->get_SeqFeatures;

my @gene_features = grep { $_->primary_tag eq 'gene' } 
                    $seq->get_SeqFeatures;
                    
my @exon_features = grep { $_->primary_tag eq 'exon' } 
                    $seq->get_SeqFeatures;     

my $accessionId = $seq->accession_number . "." . $seq->{_seq_version};
eval {
	my $moltype = ${\($source_features[0]->get_tag_values('mol_type'))};
	1;
} or do {
	my $error = $@ || 'Tag does not exist';
	warn "** Warning: Could not find mol_type tag under source";
};
my $chromosome = ${\($source_features[0]->get_tag_values('chromosome'))};
my $map = ${\($source_features[0]->get_tag_values('map'))};
my $organism = ${\($source_features[0]->get_tag_values('organism'))};
 
        
print "Here are the exons for 
   GI: $giId, 
   Accession: $accessionId, 
   Organism: $organism, 
   Chromosome: $chromosome, 
   Location: $map, 
   Mol Type: $moltype\n\n";

for my $exon_object (@exon_features) {
	print "> " . $seq->accession_number . "." . $seq->{_seq_version} .
		"|" . $exon_object->primary_tag;
	if ($exon_object->has_tag("gene")) {
		my @genes = $exon_object->get_tag_values('gene');
		print "|gene=" . $genes[0];
	} 
	print "|" . $exon_object->start . ".." . $exon_object->end . "\n";
    
    print $exon_object->spliced_seq->seq . "\n";

}   
=cut
               
