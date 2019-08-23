#!/usr/bin/env bash

####################################################################################
# Brian Wiley
# Assignment 11: Select Menu
<<COMMENT
	Add a Select Menu for Rock Paper Scissors.
COMMENT
####################################################################################


# Create array of options
options=("Rock" "Paper" "Scissors" "Quit")

# Use echo to make the direction for entry above select menue
echo -e "Please enter [1](Rock), [2](Paper), [3](Scissors) or press [4] to quit."

# Change PS3 prompt from '#?' to '> '
PS3="> "

# set selection to print out based on case
select opt in "${options[@]}"
do
	case $opt in
		"Rock") 
			echo "Paper beats rock but rock beats scissors!"
			break
			;;
		"Paper") 
			echo "Scissors beats paper but paper beats rock!"
			break
			;;
		"Scissors") 
			echo "Rock beats scissors but scissors beats paper!"
			break
			;;
		"Quit")
			exit
			;;
		*) 
			echo Incorrect entry $REPLY.
	cat <<EOF
	Usage: [1](Rock), [2](Paper), [3](Scissors) [4](Quit)
	Program only takes entry of 1, 2, 3 or 4 to quit.
EOF
		;;
	esac
done

# END





