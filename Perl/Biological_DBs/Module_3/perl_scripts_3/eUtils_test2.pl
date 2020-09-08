#! /usr/bin/perl

# https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CM000760.3&rettype=gbfull&retmode=xml

# https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NG_008847.2&rettype=gbfull&retmode=xml

# https://www.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=$db&retmax=1&usehistory=y&term=$query;
# https://www.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=nucleotide&retmax=1&usehistory=y&term=$wnt

use Bio::DB::GenBank;
use LWP::Simple;

my $utils = "https://www.ncbi.nlm.nih.gov/entrez/eutils";

my $db = "nucleotide";
my $accession  = "NG_008847.2";
my $return_mode = "xml";


my $acc_search = "$utils/efetch.fcgi?" .
              "db=$db&id=$accession&rettype=gbfull&retmode=$return_mode";

print $acc_search . "\n";

my $acc_result = get($esearch . $query);

print "\nACCESSION RESULT: $acc_result\n";

=comment
$esearch_result =~ 
  m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;

print $esearch_results . "\n";

my $Count    = $1;
my $QueryKey = $2;
my $WebEnv   = $3;

print "Count = $Count; QueryKey = $QueryKey; WebEnv = $WebEnv\n";
=cut
