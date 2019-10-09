#!/bin/bash

############################################################################
# Brian Wiley
# Assignment 7: Arrays
<<COMMENT
Create a simple script that takes two positional parameters. The first parameter 
is the initials of a player on the 1939 New York Yankees and the second is the 
index of an array containing home plate, first base, second base, and third base.
COMMENT
############################################################################

# clear screen
clear

<<COMMENT
curl -s https://community.fangraphs.com/hardball-retrospective-the-original-1939-new-york-yankees/ | 
grep -P '<td width="1[1-9]{2}">.*</td>' | 
sed 's/\(<td width="[[:digit:]]\+">\|<\/td>\)//g' > NEWFILE.txt

#names=( $(awk -v COUNT=1 'NF>COUNT' NEWFILE.txt) )
playerNames=($(gawk 'NF>1' NEWFILE.txt))

declare -A playerNamesInitials
# got initials functionality from here https://stackoverflow.com/questions/7859515/get-first-letter-of-words-using-sed
for i in ${!playerNames[@]}; do playerNamesInitials[$(echo "${playerNames[$i]}" | sed 's/\B\w*//g;s/\s//g')]="${playerNames[$i]}"; done;

# initials only 
for i in ${!playerNames[@]}; do intialsOnly[$i]=$(echo "${playerNames[$i]}" | sed 's/\B\w*//g;s/\s//g'); done;

bases=("home plate" "first base" "second base" "third base")


COMMENT
if [[ ${intialsOnly[@]} =~ (^| )"$1"($| ) ]]; then echo yes; else echo no; fi
#randomBase="${bases[RANDOM%${#bases[@]}]}"
