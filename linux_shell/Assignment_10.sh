#!/usr/bin/env bash

####################################################################################
# Brian Wiley
# Assignment 10: Here Documents
<<COMMENT
	Add a Here Document when user enters wrong entry.
COMMENT
####################################################################################

# found how to continue a case statement here: https://unix.stackexchange.com/questions/268764/how-to-repeat-prompt-to-user-in-a-shell-script
<<COMMENT
https://www.linuxjournal.com/content/return-values-bash-functions
Bash functions, unlike functions in most programming languages do not allow you to return a value to the 
caller. When a bash function ends its return value is its status: zero for success, non-zero for failure.
COMMENT

get_rps() {
	read -rp "Please enter [Rock/Paper/Scissors]? Or press [q/Q] to quit.$(echo $'\n> ')" rps
	case "${rps^^}" in
		ROCK) 
			echo "Paper beats rock but rock beats scissors!"
			return 0
			;;
		PAPER) 
			echo "Scissors beats paper but paper beats rock!"
			return 0
			;;
		SCISSORS) 
			echo "Rock beats scissors but scissors beats paper!"
			return 0	
			;;
		q|Q)
			exit
			return 0
			;;
		*) 
			echo Incorrect entry.
	cat <<EOF
	Usage: [Rock] [Paper] [Scissors]
	Program only takes entry of Rock, Paper or Scissors.
	Entry is NOT case sensitive.
EOF
			return 1
			;;
	esac
}

# This says until get_rps passes a 0 for success keep running function.  The ":" is a noop which means do nothing
# so when the function fails it does nothing and keeps going until function passes.
# https://stackoverflow.com/questions/17583578/what-command-means-do-nothing-in-a-conditional-in-bash/17583590
until get_rps; do true ; done

# END





