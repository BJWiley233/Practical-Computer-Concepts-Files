#! /usr/bin/perl

=comment
Script 1 (50 pts)
See script1_a.pl for version using XML::LibXML
currently named test1_2.pl
=cut

use strict;
#use warnings;
use LWP::UserAgent;
use XML::Simple;
#use XML::LibXML;

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

		my $xml = XML::Simple->new;
		my $data = $xml->XMLin($response->content);
		my $entry_node = $data->{entry};

		## data needed
		my $name;
		my $fullname;
		my $seq;
		
		if (defined($entry_node)) {
			$name = $entry_node->{name};
			$fullname = $entry_node->{protein}->{recommendedName}{fullName};
			$seq = $entry_node->{sequence}{content};
		}
		
		open(FHout, '>', "$_.fasta");
		
		## write to UniprotID.fasta information
		print FHout ">sp|$_|$name $fullname\n$seq";
		
	} else {
		## print error
		print STDERR "ERROR! UniProt ID $_ is not a valid id\n";
	}
	
}

close(FHin);



## for trimmming; from part_d/e in HW1
## see https://perlmaven.com/trim
sub trim {
	my $string = shift;
	## regex substitution with g modifier
	## need to dereference, I like to use '{}' for dereference
	${$string} =~ s/^\s+|\s+$//g; 

}

