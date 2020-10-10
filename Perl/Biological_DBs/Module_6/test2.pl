#! /usr/bin/perl

use strict;
use warnings;

my(@Options, $quiet, $debug, $kingdom, $fast, $force, $outdir, $prefix, $cpus, $dbdir,
             $addgenes, $addmrna, $cds_rna_olap,
             $gcode, $gram, $gffver, $locustag, $increment, $mincontiglen, $evalue, $coverage,
             $genus, $species, $strain, $plasmid, $prodigaltf,
             $usegenus, $proteins, $hmms, $centre, $scaffolds,
             $rfam, $norrna, $notrna, $rnammer, $rawproduct, $noanno, $accver,
	     $metagenome, $compliant, $listdb, $citation);

setOptions();

sub setOptions {
	use Getopt::Long;
	
my  @Options = (
    'General:',
    #{OPT=>"help",    VAR=>\&usage,             DESC=>"This help"},
    #{OPT=>"version", VAR=>\&version, DESC=>"Print version and exit"},
    #{OPT=>"citation",VAR=>\&show_citation,     DESC=>"Print citation for referencing Prokka"},
    {OPT=>"quiet!",  VAR=>\$quiet, DEFAULT=>0, DESC=>"No screen output"},
    {OPT=>"debug!",  VAR=>\$debug, DEFAULT=>0, DESC=>"Debug mode: keep all temporary files"},
    'Outputs:',
    {OPT=>"outdir=s",  VAR=>\$outdir, DEFAULT=>'', DESC=>"Output folder [auto]"},
    {OPT=>"force!",  VAR=>\$force, DEFAULT=>0, DESC=>"Force overwriting existing output folder"});

print map {$_->{OPT}, $_->{VAR}} grep { ref } @Options;
	
my %test = grep { ref } @Options;
print \%test . "\n";
for my $key (keys %test) {
	print "$key\n";
}

}

-r
