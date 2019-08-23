#!/usr/bin/env bash

############################################################################
# Brian Wiley
# Assignment 7a - Array Challenge
<<COMMENT
	Gets last names and men's and women's first names from a URL and
	stores the downloads in text files.  Then uses awk for assign the first
	column with the names into last, men, and women name arrays.  Then
	search for last_name first.  If last name not in list no bother in 
	searching first names.
COMMENT
############################################################################

# get last names, women's first names, and men's first names from simple name database using curl
curl https://www2.census.gov/topics/genealogy/1990surnames/dist.all.last --output last_name.txt
curl https://www2.census.gov/topics/genealogy/1990surnames/dist.female.first --output women_first.txt
curl https://www2.census.gov/topics/genealogy/1990surnames/dist.male.first --output men_first.txt

# using awk to import the space delimited .txt files downloaded with curl and save the first column into arrays
men=( $(awk -F" " '{print $1}' ./men_first.txt) )
women=( $(awk -F" " '{print $1}' ./women_first.txt) )
last_name=( $(awk -F" " '{print $1}' ./last_name.txt) )

# get name input
read -rp "Please enter a first and last name seperated by a space.  Do not add qotes! (-) is fine$(echo $'\n> ')" first last

# set everything to lower case because output is going to capitalize first letter of each word
first=${first,,}
last=${last,,}

# use regex to see if inputs are in arrays, first check last name then first names
if [[ ${last_name[@]} =~ (^| )"${last^^}"($| ) ]]; then 
	if [[ ${men[@]} =~ (^| )"${first^^}"($| ) ]]; then
		echo "Hello Mr. ${first^} ${last^}. Good to see you again."
	elif [[ ${women[@]} =~ (^| )"${first^^}"($| ) ]]; then
		echo "Hello Ms. ${first^} ${last^}. Good to see you again."
	else
		echo "Do I know you?"
	fi
else 
	echo "Do I know you?"
fi

# END 

# test with students' or professor's names

<<COMMENT
This also works for regex array searching using the "*"
if [[ ${men[*]} =~ (^| )"${first^^}"( |$) ]]
then 
	echo yes
else 
	echo no
fi
COMMENT
