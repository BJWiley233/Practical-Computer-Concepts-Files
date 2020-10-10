#! /usr/bin/perl

use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use Data::Dumper;
use File::Slurp;
use HTTP::Request;
use LWP::Simple;

my $url = "http://data.rcsb.org/rest/v1/core/entry/4HHB";
my $json;

my $ua = LWP::UserAgent->new;
my $response = $ua->get($url, 
								'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0)');


if ($response->is_success) {
	$json = decode_json($response->content);
	#open FH, ">", "script2_decode.txt";
	#print FH Dumper $json;
	#close FH;
}
else {
	die 
	"https status: " . $response->code . "\n";
	'Failed, got ' . $response->status_line .
	' for ' . $response->request->uri . "\n";
}

## print title
print $json->{struct}{title} . "\n";

## entry is a hash ref
for my $entry (@{$json->{citation}}) {
	if ($entry->{year} == 1975) {
		print $entry->{year} . ": " . $entry->{title} . "\n";
	}
}
