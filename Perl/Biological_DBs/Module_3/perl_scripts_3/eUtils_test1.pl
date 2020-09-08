#! /usr/bin/perl

# https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CM000760.3&rettype=gbfull&retmode=xml

# https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NG_008847.2&rettype=gbfull&retmode=gb

# https://www.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=$db&retmax=1&usehistory=y&term=$query;
# https://www.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=nucleotide&retmax=1&usehistory=y&term=$wnt

use Bio::DB::GenBank;
use LWP::Simple;

my $utils = "https://www.ncbi.nlm.nih.gov/entrez/eutils";

my $db     = "nucleotide";
my $query  = "wnt";


my $esearch = "$utils/esearch.fcgi?" .
              "db=$db&retmax=1&usehistory=y&term=";

print $esearch . "\n";

my $esearch_result = get($esearch . $query);

