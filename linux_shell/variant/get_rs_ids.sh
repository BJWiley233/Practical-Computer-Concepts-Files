#!/usr/bin/env bash

##################################################################


## Uses Heng Li's batch query script in perl to make many calls


###################################################################

FILE=batchUCSC.pl
if [[ ! -f "$FILE" ]]; then
   wget http://lh3lh3.users.sourceforge.net/download/batchUCSC.pl
   chmod u+x batchUCSC.pl
fi

printf 'HGVS_variant\tchrom\tchromStart\tchromEnd\tname\trefNCBI\trefUCSC\tobserved\n' > $2

## Need to remove the ':' because Heng's script uses as delimeter
## But we can add it back at the end
HGVS=( $(awk '{gsub(":",""); print $1}' $1) )

## set the chromosome and position 
## says end position but is the start position with 1 index and end with 0 index from UCSC
chrs=( $(grep -oP '(?<=NC_0000).+?(?=.[0-9]+:)' $1) )
endpos=( $(grep -oP '(?<=:[a-z]{1}\.).+?(?=[a-zA-Z])' $1) )

## loop though calls and make the HGVS the first column for every call in tsv file
for i in "${!HGVS[@]}"; do

   startpos=$(expr "${endpos[$i]}" - 1)

   string='snp151:chromStart:chromEnd:IF(chrom="Brian","","'"${HGVS[$i]}"'"),chrom,chromStart,chromEnd,name,refNCBI,refUCSC,observed'

   echo chr"${chrs[$i]}" $startpos "${endpos[$i]}" | ./batchUCSC.pl -d hg19 -Cp $string >> $2
done

## add the colon (:) back in the HGVS
sed -i -re 's/(.\.[0-9]+)([a-z]{1}\.)/\1:\2/' $2

