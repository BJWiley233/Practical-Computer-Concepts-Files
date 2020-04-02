#!/usr/bin/env bash

accession_version=( $(awk 'BEGIN {FS=":"} { print $1 }' $1) ) 
printf -v joined '"%s",' "${accession_version[@]}"     ## https://stackoverflow.com/questions/53839253/how-can-i-convert-an-array-to-a-comma-separated-list-in-bash
accessions=$(echo "${joined%,}")

echo \
"select set_acc as \"Assembly Accession\",
        set_chain as \"Assembly Chain\",
        set_version as \"Assembly Version\",
        name as \"Assembly Name\",           
decode(is_patch,\"N\",\"Major release\", \"Minor release\") as \"Release Type\"
from gc_assembly_set 
where tax_id = 9606 and status_id = 4 and set_acc in ($accessions)
order by set_chain, set_version;" > $2
