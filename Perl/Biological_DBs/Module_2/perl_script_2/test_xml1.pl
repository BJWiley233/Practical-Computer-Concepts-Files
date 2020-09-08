#! /usr/bin/perl

use LWP::Simple;
use XML::Simple qw(:strict);
use Data::Dumper;
use strict;
#use warnings;
use XML::Writer;

my $filename = 'test_xml.xml';
my $xml = XML::Simple->new;
my $data = $xml->XMLin($filename,
					ForceArray=>[qw(dbReference)],
					KeyAttr=>[]
					);
