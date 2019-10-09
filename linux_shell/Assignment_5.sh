#!/usr/bin/env bash

####################################################################################
# Brian Wiley
# Assignment 5: Loops; For, While, Until
# Define color of fox and dog and print with that color background
<<COMMENT
	Does countdown from 10 down to 0 using all three loop types; for, while, until.	
COMMENT
####################################################################################

start=10

#counts down to 0 using for loop
for ((i=$start; i>=0; i--)); do
	echo  $i;
	sleep 1;
done
# show ellipsis as waiting sign for 7.5 total seconds;
for ((i=1; i<=5; i++)); do
	# \r is for carriage return to the beginning of same line
	echo -ne ".\r"
	sleep 0.5
	echo -ne "..\r"
	sleep 0.5
	echo -ne "...\r"
	sleep 0.5
	echo -ne "\r\033[K" # http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html (Erase to end of line:)
done

sleep 0.5
echo "The Falcon Heavy has cleared the launchpad!";


# Use while loop
start=10
while [[ $start -ge 0 ]]; do
	echo $start
	sleep 1
	let "start -= 1"
done

sleep 5
echo "The Falcon Heavy has cleared the launchpad!";


# Use until loop
start=10
until [[ $start -lt 0 ]]; do
	echo $start
	sleep 1
	let "start -= 1"
done

sleep 5
echo "The Falcon Heavy has cleared the launchpad!";

#END