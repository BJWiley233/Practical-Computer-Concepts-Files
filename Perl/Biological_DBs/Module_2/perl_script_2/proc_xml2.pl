#! /usr/bin/perl

use LWP::Simple;
use XML::Simple;
use Data::Dumper;
use strict;
#use warnings;
use Acme::Comment type => 'C++';

#my $filename = "proc_xml1.txt";
my $filename = "proc_xml1.xml";
my $url = 'https://www.uniprot.org/uniprot/Q16539.xml';
#my $agent = LWP::UserAgent->new;
my $xml = XML::Simple->new;
my $data = $xml->XMLin($filename);
