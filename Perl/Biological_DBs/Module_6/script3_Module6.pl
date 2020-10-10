#! /usr/bin/perl

use warnings;
use strict;
use DBI;
use File::Path qw(make_path); # for directory creation
use File::Basename;
use XML::LibXML;
use Math::Round;

my $dbfile = "/home/coyote/JHU_Fall_2020/Biological_DBs/Module_3/perl_scripts_3/script2.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile");

## remove this before submitting
$dbh->do("DROP TABLE IF EXISTS Blastp;") or die $dbh->errstr;

$dbh->do("
	CREATE TABLE IF NOT EXISTS Blastp (
		AccessionID CHAR(15) NOT NULL, 
		UniProtID CHAR(15) NOT NULL, 
		EValue REAL NOT NULL,
		Identity INTEGER NOT NULL,
		IdentityPerc REAL NOT NULL,
		Coverage REAL NOT NULL,
		CONSTRAINT fk_UniProt
			FOREIGN KEY(UniProtID) REFERENCES UniProt(UniProtID)
	);"
) or die $dbh->errstr;

## output directory
my $dir = "output_data";

## https://stackoverflow.com/questions/701458/how-can-i-create-a-directory-if-one-doesnt-exist-using-perl
## https://users.cs.cf.ac.uk/Dave.Marshall/PERL/node114.html
eval { make_path($dir); 1 };
warn("Warning could not create directory '$dir'.\n") if $@;

## get files in data directory
my @files = glob("data/*xml");

for my $file (@files) {
	print "Processing file: " . basename($file) . "\n";
	
	my $uniprot_id =  basename($file) =~ s/.xml//r;
	my $outfile = $dir . "/" . $uniprot_id . ".txt";
	
	print "UniProt ID: $uniprot_id, File out: $outfile\n";

	
	## get document
	my $dom = XML::LibXML->load_xml(location => $file);
	
	## index for top 5
	my $i = 0;
	
	## filehandle to write
	open (FHout, ">", $outfile);
	
	my $query_len = $dom->findvalue("//BlastOutput_query-len");
	#print "query length = $query_len\n";
	
	foreach my $hit ($dom->findnodes('///Hit')) {
		my $accession = $hit->findvalue('./Hit_accession');
		my $hit_numb = $hit->findvalue('./Hit_num');
		$i++;
		print "Hit: $hit_numb for UniProtID $uniprot_id\tAccessionID: $accession\n";
		print FHout "Hit: $hit_numb\tAccessionID: $accession\n";

		my $eval = $hit->findvalue("./Hit_hsps/Hsp/Hsp_evalue");
		print "\te-value = $eval\n";
		my $identity = $hit->findvalue("./Hit_hsps/Hsp/Hsp_identity");
		print "\tidentity = $identity\n";
		
		## since blastp also returns identity percentage to near 1/100th
		## of percent and coverage is set at floor(coverage percent)
		
		## identity percent = round( ($identity/$align_len) * 100, 2)
		## Math::Round doesn't have # decimal places like Python/R, need to do Java way
		my $align_len = $hit->findvalue("./Hit_hsps/Hsp/Hsp_align-len");
		my $identity_perc = round($identity/$align_len * 10000 ) / 100;
		print "\tidentity_perc = $identity_perc%\n";
		
		## query coverage equals floor( ($query_aln_len/$query_len) * 100)
		## query align length = Hsp_query-to - Hsp_query-from + 1
		my $query_aln_len = ($hit->findvalue("./Hit_hsps/Hsp/Hsp_query-to") -
		                     $hit->findvalue("./Hit_hsps/Hsp/Hsp_query-from") +
		                     1);
		my $coverage = int( ($query_aln_len/$query_len) * 100 );
		print "\tcoverage = $coverage%\n";
		
		## insert data
		my $uniprot_insert = $dbh->prepare('INSERT INTO Blastp VALUES (?,?,?,?,?,?)');
		print "Inserting AccessionID $accession to database\n";
		$uniprot_insert->execute($accession, $uniprot_id, $eval, $identity, $identity_perc, $coverage) 
			or die $dbh->errstr;
		
		if ($i == 5) {
			last;
		}
	}
	close FHout;
}





=comment
AccessionID CHAR(15) NOT NULL, 
		UniProtID CHAR(15) NOT NULL, 
		EValue REAL NOT NULL,
		Identity INTEGER NOT NULL
		IdentityPerc REAL NOT NULL
		Coverage REAL NOT NULL
## get list of tables
my $sql = "SELECT name FROM sqlite_master WHERE type='table'";
my $tables = $dbh->selectcol_arrayref($sql);

## get count from each table and print
foreach my $table (@$tables) {
	my $prep = $dbh->prepare("SELECT COUNT(*) FROM $table");
	$prep->execute;
	my $length = $prep->fetchrow_arrayref->[0];
	print "$length entries were added to the $table table.\n";
}
