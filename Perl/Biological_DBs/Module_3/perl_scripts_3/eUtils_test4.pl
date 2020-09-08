#! /usr/bin/perl

use LWP::Simple;
use XML::Simple;
use Bio::DB::GenBank;
use Bio::SeqIO;
use Bio::DB::EUtilities;
use Getopt::Long;
use Pod::Usage; # https://perldoc.perl.org/Pod/Usage.html#AUTHOR
use Data::Dumper;

# https://www.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=nucleotide&retmax=97&usehistory=y&term=GCK+AND+refseq[Filter]+AND+Homo+sapiens[ORGN]

my $utils = "https://www.ncbi.nlm.nih.gov/entrez/eutils";


my $query = "GCK glucose";
my $email = 'bwiley4@jh.edu';
#my $query; # required
#my $email; # required
my $db = "nucleotide"; # default nuccore
my $refseq = 1;
my $taxid = 9606;
#my $refseq = 0; # default to not filter by refseq 
#my $taxid = 0; # default search all taxons
my $mymax = 50;
#my $mymax = 200; # default max 200
my $help = 0;
my $man = 0;

GetOptions(
	"db=s"			=> \$db,
	"query=s"       => \$query,
	"email=s"       => \$email,
	"taxid=i"		=> \$taxid,
	"max=i"         => \$mymax,
	"refseq"		=> \$refseq,
	"help"			=> \$help,
	"man"			=>\$man
);

if (!defined $query) { pod2usage(-verbose => 1); }
if (!defined $email) { pod2usage(-verbose => 1); }

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
	
	print "$taxid\n";
	print "$email\n";
              
	my $factory = Bio::DB::EUtilities->new(-eutil => 'esummary',
										   -email => $email,
										   -db    => 'taxonomy',
										   -id    => $taxid );

	my ($name) = $factory->next_DocSum->get_contents_by_name('ScientificName');

	print "$name\n";

	$esearch .= "+AND+" .  join('+', split(' ', $name)) . "[ORGN]"
}

print $esearch . "\n";

my $esearch_result = get($esearch);

print "$esearch_result\n";

$esearch_result =~ 
  m|<Count>(\d+)</Count>.*<RetMax>(\d+)</RetMax>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;

my $Count     = $1;
my $RetMax    = $2;
my $QueryKey  = $3;
my $WebEnv    = $4;

print "Count = $Count; RetMax = $RetMax; QueryKey = $QueryKey; WebEnv = $WebEnv\n";

if ($Count > 0 && $RetMax > 0) {
	print "Entering Here..................\n";
	my $xml = XML::Simple->new;
	
	#my $data = $xml->XMLin('test.xml');
	my $data = $xml->XMLin($esearch_result);
	
	#open(my $fh, '>', "out.txt");
	#print $fh Dumper($data);

	my $idList = $data->{IdList}{Id};
	foreach my $id (@$idList) {
		print $id . "\n";
	}	
};

my $pkCounter = 1;
foreach my $giId (@$idList) {
	my $factory = Bio::DB::EUtilities->new(-eutil   => 'efetch',
										   -email   => $email,
										   -db      => 'nuccore',
										   -id      => $giId,
										   -rettype => 'gb');
	
	
	if (defined($gb_response->{_content}) {
		my @features = Bio::SeqIO->new(-string => $gb_response->{_content})->next_seq->get_SeqFeatures;
	}
	
	#... see test.pl in this folder
}
=comment
loop to get features from all
my $factory = Bio::DB::EUtilities->new(-eutil   => 'efetch',
									   -email   => 'bwiley4@jh.edu',
									   -db      => 'nuccore',
									   -id      => 'NG_008847.2',
									   -rettype => 'gb');


my @features = Bio::SeqIO->new(-string => $gb_response->{_content})->next_seq->get_SeqFeatures;
	
print $features . "\n";
foreach my $feat_object (@features) {
	print $feat_object . "\n";
}

=cut
