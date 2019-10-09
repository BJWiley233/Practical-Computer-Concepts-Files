#!/usr/bin/env bash

####################################################################################
# Brian Wiley
# Assignment 3: Positional Parameters
# Define color of fox and dog and print with that color background
<<COMMENT
	Linux shell scripting does not distinguis variable types and
	all Bash variables are considered strings.  
	See https://www.tldp.org/LDP/abs/html/untyped.html
	
	Loops through all the input parameters and lists out
	the classification of each parameter: 
	int; if all numbers w/o spaces or decimal point (ex. 1, 02, 9993)
	double; if all numbers w/o space but w/ decimal (ex. 1., 1.0, 0.2, 200.3333333)
	char; if character of length 1 (ex. a, z, E, -, ., :)
	date; valid date format (ex. 
	string; more than one character and includes at least 1 character
		    (ex. 1A, AB1CD, Brian, cross-complaint, 0:4, "11 11")
			** basically anything else not classified above
	
COMMENT
####################################################################################

# Clear the screen before starting.
clear

<<COMMENT
Print colors to choose; source https://askubuntu.com/questions/558280/changing-colour-of-text-and-background-of-terminal
for((i=0; i<256; i++)); do
    printf "\e[48;5;${i}m%03d" $i;
    printf '\e[0m';
    [ ! $((($i - 15) % 6)) -eq 0 ] && printf ' ' || printf '\n'
done
COMMENT

# define variables, sentence from assignment as slice positional parameters
sentence="The quick brown fox leaped over the lazy yellow dog."

# \e[<fg_bg>;5;<ANSI_color_code>m ## Format for printing color background (48) and text (38)
#brown_bkg=\e[48;5;94m
#yellow_bkg=\e[48;5;190m
#black_text=\e[38;5;0m
#reset_bkg_text=\e[0m

# First test that the input parameters equals the sentence for the assignment
if [[ "$@" = "$sentence" ]]
then
	# this checks if sentence matches but is one parameter due to quotes (single or double)
	if [[ "$#" = 1 ]]
	then
		# if so set as array
		#This used to work
		#$@ = ( $@ )
		fox_color="$3" # slice 3rd word
		dog_color="${@:~1:1}"  ## slice starts at second to last word (~1) in array and length 1
		printf "The fox is \e[48;5;94m${fox_color}\e[0m and the dog is \e[38;5;0m\e[48;5;190m${dog_color}\e[0m.\n"
	# else print color of fox highlighting that color and color of dog highlighting that color
	else
		fox_color="$3" # slice 3rd word
		dog_color="${@:~1:1}"  ## slice starts at second to last word (~1) in array and length 1
		printf "The fox is \e[48;5;94m${fox_color}\e[0m and the dog is \e[38;5;0m\e[48;5;190m${dog_color}\e[0m.\n"
	fi
else
	# If not assignment sentence go through the list of positional parameters and review variable type criteria
	for ((i = 1; i <= $#; ++i))
	do
		# check if date is valid, 2nd conditional prevents passing up to 24 hours which is valid date, and 3rd condition prevents 1 character date parameters
		if (date --date "${!i}" > /dev/null 2>&1) && [[ ! ${!i} =~ ^[-+]?[0-9]+$ ]] && [[ ! ${!i} =~ ^[a-zA-Z]$ ]]
		then 
			printf '%s\n' "Arg $i: ${!i} is a date."
		<<COMMENT
		Regex check if string is integer (answer from Peter Ho https://stackoverflow.com/questions/2210349/test-whether-string-is-a-valid-integer)
		(^) means start of string
		([-+]) means literal for minus or plus
		(?) means check for preceding "0 doesn't have it or 1 has it"
		([0-9]) numbers 0 to 9
		(+) is there one or more of the preceding
		($) end of input pattern
COMMENT
		elif [[ ${!i} =~ ^[-+]?[0-9]+$ ]]
		then
			printf '%s\n' "Arg $i: ${!i} is an int."
		# check with regex if entry is double (Numbers followed by . but no additional numbers are not double; ex [14.] is not a double
		elif [[ ${!i} =~ ^[-+]?[0-9]*\.?[0-9]+$ ]]
		then
			printf '%s\n' "Arg $i: ${!i} is a double."
		# check with regex if entry is not a number and length of 1 for char else greater than lenght 1 is string
		elif [[ ! ${!i} =~ ^[0-9]?$ ]] && [[ $(echo -n "${!i}" | wc -m) == 1 ]]
		then
			printf '%s\n' "Arg $i: ${!i} is a char."
		# else print type is string
		else
			printf '%s\n' "Arg $i: ${!i} is a string"
		fi
	done
fi

# END

# tests
# ./Assignment_3.sh The quick brown fox leaped over the lazy yellow dog.
	# prints "The fox is brown and the dog is yellow." with correct highlighting
# ./Assignment_3.sh 'The quick brown fox leaped over the lazy yellow dog.'
	# prints "The fox is brown and the dog is yellow." with correct highlighting
# ./Assignment_3.sh "The quick brown fox leaped over the lazy yellow dog."
	# prints "The fox is brown and the dog is yellow." with correct highlighting	
	
# ./Assignment_3.sh The quick brown fox leaped over the lazy yellow "11 11"
	# prints all 10 args as strings
# ./Assignment_3.sh The "Maybe3, 20155" +123 120000.13 1 May cc c
	# prints 1)string 2)string 3)int 4)double 5)int 6)string 7)string 8)char
# ./Assignment_3.sh "May 13, 2019" porcupine-p 12/31 12/40 +-110 110. 110.0 1
	# prints 1)date 2)string 3)date 4)string 5)string 6)string 7)double 8)int

	