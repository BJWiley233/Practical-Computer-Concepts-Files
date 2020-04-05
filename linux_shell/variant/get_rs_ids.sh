#!/usr/bin/env bash

FILE=batchUCSC.pl
if [[ ! -f "$FILE" ]]; then
   wget https://raw.githubusercontent.com/lh3/misc/master/biodb/batchUCSC.pl
   chmod u+x batchUCSC.pl
fi

printf 'HGVS_variant\tchrom\tchromStart\tchromEnd\tname\trefNCBI\trefUCSC\tobserved\n' > $2

## Need to remove the ':' because Heng's script uses as delimeter
## But we can add it back at the end
HGVS=( $(awk '{gsub(":",""); print $1}' $1) )

## set the chromosome and position 
## says end position but is the start position with 1 index and end with 0 index from UCSC
## avoid look behind https://stackoverflow.com/questions/21077882/pattern-to-get-string-between-two-specific-words-characters-using-grep
chrs=( $(grep -oP '(NC_[0]+\K).+?(?=.[0-9]+:)' $1) )
endpos=( $(grep -oP '(?<=:[a-z]{1}\.).+?(?=[a-zA-Z])' $1) )
ref=()
for f in "${HGVS[@]}" ; do
   ref+=( ${f: -3 : 1} )
done 
alt=()
for f in "${HGVS[@]}" ; do
   alt+=( ${f: -1 : 1} )
done 

## loop though calls and make the HGVS the first column for every call in tsv file
for i in "${!HGVS[@]}"; do

   startpos=$(expr "${endpos[$i]}" - 1)

   string='snp151:chromStart:chromEnd:IF(chrom="Brian","","'"${HGVS[$i]}"'"),chrom,chromStart,chromEnd,name,refNCBI,refUCSC,observed'

   echo chr"${chrs[$i]}" $startpos "${endpos[$i]}" | ./batchUCSC.pl -d hg19 -Cp $string >> $2
done


## example:
## ./get_rs_ids.sh snps.txt rs_ids.tsv
## download snps.txt from https://github.com/BJWiley233/Practical-Computer-Concepts-Files/blob/master/linux_shell/variant/snps.txt
