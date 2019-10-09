#!/bin/bash

##############################################################################################
# Brian Wiley
# Assignment 7: Arrays
<<COMMENT
Create a SIMPLE script that takes two positional parameters. The first parameter 
is the initials of a player on the 1939 New York Yankees and the second is the 
index of an array containing home plate, first base, second base, and third base.
Must enter number 0-3 for the bases (0=home plate, 1=first base, 2=second base, 3=third base)
COMMENT
##############################################################################################

# clear screen
clear

# create array for bases
bases=("home plate" "first base" "second base" "third base")

# tested with two sets of intials or second parameter mix of letters and got 'home plate' [zzz, k2, a1] or 'value to great' error [12a, 1b, 3d] so need to correct for this using grep
if [[ ! $2 ]] ||  [[ ! $2 =~ ^[0-3]?$ ]]; then
	set -- "${@:1:1}" "9999" # this is an unfortunate need https://stackoverflow.com/questions/4827690/how-to-change-a-command-line-argument-in-bash
fi

# use curl to fetch HTML for player information
curl -s https://community.fangraphs.com/hardball-retrospective-the-original-1939-new-york-yankees/ | 
# use grep to get players between td tags that have width in the 100s 
grep -P '<td width="1[1-9]{2}">.*</td>' | 
# use sed to get info between tags.  must use [[:digits:]] instead of \d because sed is not perl; https://superuser.com/questions/513412/how-to-match-digits-followed-by-a-dot-using-sed
sed 's/\(<td width="[[:digit:]]\+">\|<\/td>\)//g' > NEWFILE.txt


# set Internal Field Seperator to newline before importing players
IFS=$'\n'
# got some weird tags and needed to only import the ones with two words(names)
playerNames=($(gawk 'NF>1' NEWFILE.txt)) # https://superuser.com/questions/470283/grep-find-line-with-minimum-x-words

# remove dups since it was easier than seeing which tags to import
declare -A playerNamesRemoveDups
for i in ${!playerNames[@]}; do playerNamesRemoveDups[${playerNames[$i]}]=${playerNames[$i]}; done

# create associative array with players initials and their full names
declare -A playerNamesInitials
# got initials functionality from here https://stackoverflow.com/questions/7859515/get-first-letter-of-words-using-sed (I still only know that \B negates word boundry but rest I am still researching)
for i in ${playerNamesRemoveDups[@]}; do 
	playerNamesInitials[$(echo "${i}" | sed 's/\B.//g;s/\s//g')]+="${i}, "; # need to do += because there are multiple players with same initials
done;

# if valid initials and base
if [[ ${playerNamesInitials[${1^^}]} ]] && [[ ${bases[$2]} ]]; then 
	output="$(echo "${playerNamesInitials[${1^^}]} were/was on the 1939 Yankees team.")";  
	echo -e "${output/,  / }\n"; # this fixes output for the extra ', ' at the end of associative array 
	cuts=$(echo ${playerNamesInitials[${1^^}]} | grep -o "," | wc -l) # this finds how many names are associated with initials
	randomCut=$(echo $((1 + RANDOM % $cuts))) # need to store index of randomCut for if statement below
	player=$(cut -d "," -f $randomCut <<<${playerNamesInitials[${1^^}]}) # get player with cut
	if [[ "$randomCut" -gt 1 ]]; then # if cut is not first must replace print output
		echo -e "${player/ /} is on/at ${bases[$2]}.\n"
	else
		echo -e "${player} is on/at ${bases[$2]}.\n"
	fi
# if valid initials but not valid base
elif [[ ${playerNamesInitials[${1^^}]} ]] && [[ !  ${bases[$2]} ]]; then
	output="$(echo "${playerNamesInitials[${1^^}]} were/was on the 1939 Yankees team.")";  
	echo -e "${output/,  / }\n";
	cuts=$(echo ${playerNamesInitials[${1^^}]} | grep -o "," | wc -l)
	randomCut=$(echo $((1 + RANDOM % $cuts)))
	player=$(cut -d "," -f $randomCut <<<${playerNamesInitials[${1^^}]})
	if [[ "$cuts" -gt 1 ]]; then
		echo -e "You entered an incorrect base or no base.  ${player/ /} is on/at "${bases[RANDOM%${#bases[@]}]}".\n"
	else
		echo -e "You entered an incorrect base or no base.  ${player} is on/at "${bases[RANDOM%${#bases[@]}]}".\n"
	fi
# if not valid initials or valid base
else 
	echo -e "Sorry there is no player with initials '${1^^}' on the 1939 Yankees team.\n"; 
	echo -e "But "${playerNames[RANDOM%${#playerNames[@]}]}" is on/at "${bases[RANDOM%${#bases[@]}]}".\n" ; 
fi

# END

# tests
# ./Assignment_7.sh rva 3 3
	# Russ Van Atta were/was on the 1939 Yankees team.
	# Russ Van Atta is on/at third base.
# ./Assignment_7.sh rva 7
	# Russ Van Atta were/was on the 1939 Yankees team.
	# You entered an incorrect base or no base.  Russ Van Atta is on/at [first base, second base, third base, or home plate].
# ./Assignment_7.sh lg lg
	# Lefty Gomez, Lou Gehrig, Len Gabrielson were/was on the 1939 Yankees team.
	# You entered an incorrect base or no base.  [Lefty Gomez, Lou Gehrig, or Len Gabrielson] is on/at [first base, second base, third base, or home plate].
# ./Assignment_7.sh LG 2
	# Lefty Gomez, Lou Gehrig, Len Gabrielson were/was on the 1939 Yankees team.
	# [Lefty Gomez, Lou Gehrig, or Len Gabrielson] is on/at second base.
# ./Assignment_7.sh bw
	# Billy Werber were/was on the 1939 Yankees team.
	# You entered an incorrect base or no base.  Billy Werber is on/at [first base, second base, third base, or home plate].
# Assignment_7.sh 12 12
	# Sorry there is no player with initials '12' on the 1939 Yankees team.
	# But [random player] is on/at [first base, second base, third base, or home plate].