#!/usr/bin/env bash

<<COMMENT
	Prints a "Hello World Message" to stdout.  Then continually asks
	for another input to say "Hello" to unless use enters 'q' for quit.
COMMENT
# Brian Wiley
# Assignment 1

# assign boolean variable
quit=0
# print message
echo -e "\nHello World!\n"

# while boolean is false continue to ask for input
while [ "$quit" -eq 0 ]
do
	# Read input from user with -rp options. -r is for including backslashes and -p is for prompt
	read -rp "Who/where/what else do you want to say hello to? Or press [q/Q] to quit.$(echo $'\n> ')" var_PPT
	if [ "${var_PPT^^}" == "Q" ]
	then
		quit=1
	else 
		echo -e "\nHello ""$var_PPT""!\n"
	fi
done

# END
