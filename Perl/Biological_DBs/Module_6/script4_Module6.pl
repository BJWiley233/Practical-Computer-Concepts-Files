#! /usr/bin/perl

use warnings;
use strict;
use DBI;
use XML::LibXML;
use LWP::UserAgent;
use Data::Dumper;
use JSON;
use File::Slurp; # just handy to use
use XML::Simple;


## set UserAgent
my $ua = LWP::UserAgent->new;

#my $pdbid = "3EML";


my $dbfile = "/home/coyote/JHU_Fall_2020/Biological_DBs/Module_3/perl_scripts_3/script2.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile");

## remove this before submitting
#$dbh->do("DROP TABLE IF EXISTS DrugBank;") or die $dbh->errstr;

$dbh->do("
	CREATE TABLE IF NOT EXISTS DrugBank (
		DrugBankID CHAR(15) NOT NULL, 
		PDBID CHAR(5) NOT NULL, 
		DrugShort CHAR(5) NOT NULL,
		DrugLong TEXT NOT NULL,
		CONSTRAINT fk_Structures
			FOREIGN KEY(PDBID) REFERENCES Structures(PDBID)
	);"
) or die $dbh->errstr;

my $sql = 'SELECT PDBID FROM Structures';
my $pdbids = $dbh->selectcol_arrayref($sql);
#print $pdbids->[0] . "\n";
#my $pdbid = $pdbids->[0];

foreach my $pdbid (@$pdbids) {
	print $pdbid . "\n";
	## PDBe Drug Bank URL 
	my $pdb_dbUrl = "https://www.ebi.ac.uk/pdbe/api/pdb/entry/drugbank/$pdbid";

	## get pdb_dbUrl response
	my $response = $ua->get($pdb_dbUrl,
									"User-Agent" => "Mozilla/4.0 (compatible; MSIE 7.0)");

	## get as much info as possible if not success
	unless ($response->is_success) {
		die "https status: " . $response->code . "\n";
			 "Failed, got " . $response->status_line .
			 " for " . $response->request->uri . "\n";
	}

	my $decoded_json = decode_json($response->content);

	#my $decoded_json = decode_json(read_file("script4_drugbank.json"));

	## prepare insert into drug table
	my $drug_insert = $dbh->prepare("INSERT INTO DrugBank VALUES (?,?,?,?)");

	my $pubchem_url;
	my $pubchem_response;

	foreach my $pdb (keys %$decoded_json) {
		#print "$pdb: " . $decoded_json->{$pdb} . "\n";
		my $pdb_arr = $decoded_json->{$pdb};
		## array of length 1 holding 1 hash
		foreach my $hash (@$pdb_arr) {
			foreach my $drugShort (keys %$hash) {
				my $drugbank_id = $hash->{$drugShort}->{drugbank_id};
				#print $drugShort . ": " . $drugbank_id . "\n";
				
				$pubchem_url = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/substance/sourceid/drugbank/$drugbank_id/XML";
				
				$pubchem_response = $ua->get($pubchem_url,
													  'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
				unless ($pubchem_response->is_success) {
				die "pubchem_response https status: " . $pubchem_response->code . "\n";
					 "Failed, got " . $pubchem_response->status_line .
					 " for " . $pubchem_response->request->uri . "\n";
				}	
				
				my $dom = XML::LibXML->load_xml(string => $pubchem_response->content);
				
				## need to register prefix for namespace; can be any prefix
				## See: https://www.perlmonks.org/?node_id=555011
				my $xc = XML::LibXML::XPathContext->new($dom);
				my $prefix = 'brian';
				# https://metacpan.org/pod/distribution/XML-LibXML/lib/XML/LibXML/XPathContext.pod
				$xc->registerNs($prefix, "http://www.ncbi.nlm.nih.gov");
			
				#my ($synonyms) = $xc->findnodes("//$prefix:PC-Substances/$prefix:PC-Substance/$prefix:PC-Substance_synonyms/$prefix:PC-Substance_synonyms_E");
				my ($synonyms) = $xc->findnodes("//$prefix:PC-Substance_synonyms_E");
				#print $synonyms->textContent . "\n";
		
				
				#my $xml = XML::Simple->new;
				#my $data = $xml->XMLin($pubchem_response->content);
				
				#open(DrugOut, ">", "drug_out.txt");
				#print DrugOut Dumper $data;			
				$drug_insert->execute($drugbank_id, $pdbid, $drugShort, $synonyms->textContent);
							  
				
				#my $first_full_name = $dom->findvalue("/PC-Substances/PC-Substance/PC-Substance_synonyms/PC-Substance_synonyms_E");
				#print "$first_full_name\n";
				
			}
		}
	}
}

=comment
## get pdb_dbUrl response
my $response = $ua->get($pdb_dbUrl,
							   "User-Agent" => "Mozilla/4.0 (compatible; MSIE 7.0)");


## get as much info as possible if not success
unless ($response->is_success) {
	die "https status: " . $response->code . "\n";
		 "Failed, got " . $response->status_line .
		 " for " . $response->request->uri . "\n";
}

my $decoded_json = decode_json($response->content);


## Each JSON entry from PDBe API has only 1 parent,
## the PDB id using lower case letters so we can
## Either change PDB id to lowercase or just use foreach
## which is just 1 iteration of a loop

#open(FH, ">", "script4_drugbank.txt");
#print FH Dumper $decoded_json;

#open(FHjson, ">", "script4_drugbank.json");
#print FHjson encode_json($decoded_json);
