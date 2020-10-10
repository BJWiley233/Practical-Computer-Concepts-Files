#! /usr/bin/perl

=comment
Script 1 (50 pts)
See script1_a.pl for version using XML::LibXML
=cut

use strict;
#use warnings; ## suppresses all the warnings printed from XML::Simple
use LWP::UserAgent;
use XML::Simple;
use File::Path qw(make_path);

my $dir = "/input_data_test";

eval { make_path($dir); 1 };

warn("Warning could not create directory $dir.\n") if $@;
