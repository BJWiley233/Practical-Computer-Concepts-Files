#! usr/bin/perl
# An example script demonstrating the use of BioMart API.
# This perl API representation is only available for configuration versions >=  0.5 
use strict;
use BioMart::Initializer;
use BioMart::Query;
use BioMart::QueryRunner;

my $confFile = "/home/coyote/tools/biomart-perl/conf/myNewRegistry1.xml";
#
# NB: change action to 'clean' if you wish to start a fresh configuration  
# and to 'cached' if you want to skip configuration step on subsequent runs from the same registry
#

my $action='clean';
my $initializer = BioMart::Initializer->new('registryFile'=>$confFile, 'action'=>$action);
my $registry = $initializer->getRegistry;

my $query = BioMart::Query->new('registry'=>$registry,'virtualSchemaName'=>'default');

		
	$query->setDataset("hsapiens_snp");
	$query->addFilter("variation_source", ["dbSNP"]);
	$query->addFilter("snp_filter", ["rs746191123","rs968150359","rs1596519823","rs202066338","rs1601985311","rs1591161664","rs1573578602","rs1597801649","rs746853821","rs1555287661","rs1380135986","rs1270552356","rs80359062","rs1555287666","rs1555284566","rs748609599","rs1555288169","rs1555591746","rs1555581922","rs1333635543","rs876660734","rs1554556582","rs1555280344","rs778602038","rs142063461","rs780020495","rs1555607258","rs779504604","rs1064795885","rs140510381","rs143160357","rs879255309","rs137976282","rs878855151","rs878855122","rs150949949","rs878853931","rs876661065","rs876659600","rs767306337","rs863225441","rs863224759","rs570278423","rs794728018","rs786203192","rs786203008","rs368291318","rs373257776","rs564652222","rs587782889","rs587781948","rs587781840","rs587781837","rs587781707","rs3738888","rs587780639","rs587778582","rs147523071","rs587780214","rs121908698","rs555607708","rs587780021","rs147453999","rs62625284","rs180177133","rs180177132","rs180177111","rs180177102","rs180177097","rs398122712","rs80358116","rs81002825","rs397507802","rs11571833","rs80357888","rs149364097","rs80357868","rs1800566","rs112294663","rs1801320","rs1800470","rs121964873","rs137852576","rs1799796","rs28997576","rs1045485","rs137853011","rs17879961","rs137852986","rs137852985","rs28903098","rs1800054","rs28904921","rs104894136","rs118203999","rs118203998","rs1801155"]);
	$query->addAttribute("refsnp_id");
	$query->addAttribute("refsnp_source");
	$query->addAttribute("chr_name");
	$query->addAttribute("chrom_start");
	$query->addAttribute("chrom_end");

$query->formatter("TSV");

my $query_runner = BioMart::QueryRunner->new();
############################## GET COUNT ############################
# $query->count(1);
# $query_runner->execute($query);
# print $query_runner->getCount();
#####################################################################


############################## GET RESULTS ##########################
# to obtain unique rows only
# $query_runner->uniqueRowsOnly(1);

$query_runner->execute($query);
$query_runner->printHeader();
$query_runner->printResults();
$query_runner->printFooter();
#####################################################################
