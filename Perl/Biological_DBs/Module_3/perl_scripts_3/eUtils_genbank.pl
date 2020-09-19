#! /usr/bin/perl

use LWP::Simple;
use XML::Simple;
#use Bio::DB::GenBank;
use Bio::SeqIO;
use Bio::DB::EUtilities;
use Getopt::Long;
use Pod::Usage; # https://perldoc.perl.org/Pod/Usage.html#AUTHOR
use Data::Dumper;

# https://www.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=nucleotide&retmax=97&usehistory=y&term=GCK+AND+refseq[Filter]+AND+Homo+sapiens[ORGN]

my $utils = "https://www.ncbi.nlm.nih.gov/entrez/eutils";


my $query = "GCK glucose";
my $email = 'bwiley4@jh.edu';
my $db = "nucleotide"; # default nuccore/nucleotide
my $refseq = 0; # default to not filter by refseq 
my $taxid = 0; # default search all taxons
my $mymax = 5; # default max 5
my $help = 0;
my $man = 0;

GetOptions(
	"db=s"			=> \$db,
	"query=s"       => \$query,
	"email=s"       => \$email,
	"taxid=i"		=> \$taxid,
	"max-return=i"  => \$mymax,
	"refseq"		=> \$refseq,
	"help"			=> \$help,
	"man"			=>\$man
);

if (!defined $query) { pod2usage(-verbose => 1); }
if (!defined $email) { pod2usage(-verbose => 1); }
pod2usage(-verbose => 1) if $help;
pod2usage(-verbose => 2) if $man;

my $esearch = "$utils/esearch.fcgi?" . "db=$db" .
              "&usehistory=y";
             
if ($mymax) {
	$esearch .= "&retmax=$mymax";
}

## split query terms and join with '+'
$esearch .= "&term="  . join('+', split(' ', $query));

if ($refseq) {
	$esearch .= "+AND+refseq[Filter]";
}

if ($taxid) {

	my $factory = Bio::DB::EUtilities->new(-eutil => 'esummary',
										   -email => $email,
										   -db    => 'taxonomy',
										   -id    => $taxid );

	my ($name) = $factory->next_DocSum->get_contents_by_name('ScientificName');

	$esearch .= "+AND+" .  join('+', split(' ', $name)) . "[ORGN]"
}

my $esearch_result = get($esearch);

$esearch_result =~ 
  m|<Count>(\d+)</Count>.*<RetMax>(\d+)</RetMax>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;

my $Count     = $1;
my $RetMax    = $2;
my $QueryKey  = $3;
my $WebEnv    = $4;

print "url= $esearch\n"; 
print "******** Count = $Count; RetMax = $RetMax; QueryKey = $QueryKey; WebEnv = $WebEnv ********\n\n";

my $idList;  ## reference to ids

if ($Count > 0 && $RetMax > 0) {
	
	my $xml = XML::Simple->new;
	
	## need to force array here because if max entry is 1 it won't
	## be an array.  It the same thing for the DocumentSummarySet
	## in Bio.Entrex for BioPython
	my $data = $xml->XMLin($esearch_result,
						   ForceArray=>["Id"],
					       KeyAttr=>[]);

	$idList = $data->{IdList}{Id};

	#open(FH, ">", "comeon.txt");
	#print FH Dumper($data);
}

#my $pkCounter = 1; ## was going to dump to sqlite database in another script

foreach my $giId (@$idList) {
	
	my $factory = Bio::DB::EUtilities->new(-eutil   => 'efetch',
										   -email   => $email,
										   -db      => $db,
										   -id      => $giId,
										   -rettype => 'gb');
	
	my $gb_response = $factory->get_Response;
		
	if (defined($gb_response->{_content})) {
		my $seq = Bio::SeqIO->new(-string => $gb_response->{_content})->next_seq;
		
		## get all features
		my @features = $seq->get_SeqFeatures;
		
		## see these links for what you can do with the @features and the tags
		## https://stackoverflow.com/questions/22073986/how-do-i-get-gene-features-in-fasta-nucleotide-format-from-ncbi-using-perl
		## https://bioperl.org/howtos/Features_and_Annotations_HOWTO.html
		
		## get single type of features
		my @source_features = grep { $_->primary_tag eq 'source' } 
						      $seq->get_SeqFeatures;

		my @gene_features = grep { $_->primary_tag eq 'gene' } 
						    $seq->get_SeqFeatures;
						
		## Example only exons
		my @exon_features = grep { $_->primary_tag eq 'exon' } 
						    $seq->get_SeqFeatures;   
		
		
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
		
		if ($db eq "protein") {
			## most GenPept files do not have exon annotations  
			my @CDS_features = grep { $_->primary_tag eq 'CDS' } 
						       $seq->get_SeqFeatures;   
			
			for my $CDS_object (@CDS_features) {
				print "> " . $seq->accession_number . "." . $seq->{_seq_version} .
					"|" . $CDS_object->primary_tag;
				if ($CDS_object->has_tag("gene")) {
					my @genes = $CDS_object->get_tag_values('gene');
					print "|gene=" . $genes[0];
				} 
				print "|" . $CDS_object->start . ".." . $CDS_object->end . "\n";
				
				print $CDS_object->spliced_seq->seq . "\n";
			}
		} else {
			## just give exons			       
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
		}

		
	}
	print("\n\n\n"); 						
}


__END__

=head1 NAME

Search database and get features.  This only returns exons for nucleotide
and nuccore db and CDS for protein db.
Only allows for 'nucleotide', 'nuccore', or 'protein'.
I figured a way to get NG and NC reference number from 'gene' database
but it requires parsing the Entrezgene file for the genomic accessions.
It's a pain in the butt.

=head1 SYNOPSIS

eUtils_genbank.pl -q [query] -e [e-mail] [OPTIONS...]

=head1 Output Format

stdout

=head1 Required Parameters

=over

=item B<-q, --query>=<String>

The query string to query.  Multiple spaced words must be encapsulated
in single or double quotes

=over

=item Examples: 

=item -q PI3k

=item -q 'Estrogen and progesterone positive Breast cancer'

=item --query pi3k/akt

=back

=item B<-e, --email>=<String>

Enter a valid e-mail address

=back

=head1 Options

=over

=item B<--max-return>=<number>

How many max database entries to return

=item B<-t, --taxid>=<number>

Option filter by tax id

=item B<-r, --refseq>

Option to filter by only RefSeq entries

=item B<-d, --db>=<String>

Database option.  Default is 'nucleotide'.
Only allows for 'nucleotide', 'nuccore', or 'protein'.
I figured a way to get NG and NC reference number from 'gene' database
but it requires parsing the Entrez gene file for the genomic accessions.
It's a pain.

=back

=head1 AUTHOR

Brian Wiley L<bwiley4@jh.edu>

=head1 EXAMPLES

=over

=item perl eUtils_genbank.pl -q 'GCK glucose' -e yourEmail@school.edu --max-return 5 -t 9606 --refseq

=item perl eUtils_genbank.pl -q pi3k/akt -e email@jhu.edu -d protein --max-return 1 -t 9606 -r 
(won't return exons and most GenPept don't include this)

=back

=cut

	

