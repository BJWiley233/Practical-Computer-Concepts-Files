#! /usr/bin/perl

=comment
Script 1 (50 pts)
Alternative for version using XML::LibXML
with XML::LibXML::XPathContext for Namespaces
=cut

use strict;
#use warnings;
use LWP::UserAgent;
use XML::LibXML;

## Open file with filehandle in
open(FHin, "<:encoding(utf8)", "HW2_1.txt") or die $!;

## set UserAgent
my $ua = LWP::UserAgent->new;

## for each line in FHin
while (<FHin>) {
	chomp $_;
	
	## get UniProt ID after 'Uniprot:' using s replace
	$_ =~ s/.*://;
	## trim white space
	trim(\$_);
	
	## if valid form get response and write info
	if ($_ =~ /^[a-zA-Z](\d+){5}/) {
	
		my $response = $ua->get("https://www.uniprot.org/uniprot/$_.xml",
					'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');
		unless ($response->is_success) {
			die 
			"https status: " . $response->code . "\n";
			'Failed, got ' . $response->status_line .
			' for ' . $response->request->uri . "\n";
		}
		
		## get document
		my $dom = XML::LibXML->load_xml(string => $response->content);
		
		## need to register prefix for namespace; can be any prefix
		## See: https://www.perlmonks.org/?node_id=555011
		my $xc = XML::LibXML::XPathContext->new($dom);
		my $prefix = 'brian';
		# https://metacpan.org/pod/distribution/XML-LibXML/lib/XML/LibXML/XPathContext.pod
		$xc->registerNs($prefix, "http://uniprot.org/uniprot");

		## data needed
		my ($name) = $xc->findnodes("//$prefix:uniprot/$prefix:entry/$prefix:name");
		my ($fullname) = $xc->findnodes("//$prefix:uniprot/$prefix:entry/$prefix:protein/$prefix:recommendedName/$prefix:fullName");
		my ($seq) = $xc->findnodes("//$prefix:uniprot/$prefix:entry/$prefix:sequence");

		## open fasta
		open(FHout, '>', "$_.fasta");
		
		## write to UniprotID.fasta information
		print FHout ">sp|$_|". $name->textContent . " " . 
			$fullname->textContent . "\n" . $seq->textContent;
			
		## close fasta
		close(FHout);
		
	} else {
		## print error
		print STDERR "ERROR! UniProt ID $_ is not a valid id\n";
	}
	
}

## close HW2_1.txt
close(FHin);



## for trimmming; from part_d/e in HW1
## see https://perlmaven.com/trim
sub trim {
	my $string = shift;
	## regex substitution with g modifier
	## need to dereference, I like to use '{}' for dereference if '$$'
	${$string} =~ s/^\s+|\s+$//g; 

}

