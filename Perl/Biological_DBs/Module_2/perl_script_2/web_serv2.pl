#! usr/bin/perl

use LWP::Simple;
use strict;
use warnings;

my $db = 'uniprotkb';
my $id = 'Q16539';
my $format = 'uniprot';
my $style = 'raw';

my $agent = LWP::UserAgent->new;
my $url = 'http://www.ebi.ac.uk/Tools/dbfetch/dbfetch';

my (%post_data) = (
				'db' => $db,
				'id' => $id,
				'format' => $format,
				'style' => $style,
				);

#print $post_data{'db'}, "\n";
#print \%post_data, "\n";
				
my $response = $agent->post($url, \%post_data);
if ($response->is_success) {
	#print $response->content . "\n";
	print $response->headers->as_string . "\n";
}
else {
	die 'Failed, got ' . $response->status_line . 
	  ' for ' . $response->request->uri . "\n";
}
				
				
				
				
				
				
