#!/usr/bin/perl


use strict;
use warnings;

use XML::LibXML;
use XML::LibXML::XPathContext;

my $filename = 'P32214.xml';

my $dom = XML::LibXML->load_xml(location => $filename);

=comment
UniProt XML has namespace, i.e. xmlns
<uniprot xmlns="http://uniprot.org/uniprot" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"...
See: https://www.perlmonks.org/?node_id=555011
=cut

my $xc = XML::LibXML::XPathContext->new($dom);
my $prefix = 'brian';

# https://metacpan.org/pod/distribution/XML-LibXML/lib/XML/LibXML/XPathContext.pod
$xc->registerNs($prefix, "http://uniprot.org/uniprot");


my ($name) = $xc->findnodes("//$prefix:uniprot/$prefix:entry/$prefix:name");
my ($fullname) = $xc->findnodes("//$prefix:uniprot/$prefix:entry/$prefix:protein/$prefix:recommendedName/$prefix:fullName");
my ($seq) = $xc->findnodes("//$prefix:uniprot/$prefix:entry/$prefix:sequence");

print "Name is: " . $name->textContent . "\n";
print "fullname is: " . $fullname->textContent . "\n";
print "seq is: " . $seq->textContent . "\n";
