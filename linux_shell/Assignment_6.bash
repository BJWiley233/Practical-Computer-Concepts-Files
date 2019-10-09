#!/bin/bash

############################################################################
# Brian Wiley
# Assignment 6: Functions
<<COMMENT
	Functions to greet user and displays PATH, PWD, USER, and DATE/TIME
COMMENT
############################################################################

# clear screen
clear

# greeting function
greeting() {
# get current hour (24 hour clock format i.e. 0-23)
hour=$(date +"%H")

# if it is midnight to midafternoon will say g'morn
if [ $hour -ge 0 ] && [ $hour -lt 12 ]; then
	greet="Good Morning, $(whoami)"
# if it is midafternoon to evening will say g'aft
elif [ $hour -ge 12 ] && [ $hour -lt 18 ]; then
	greet="Good Afternoon, $(whoami)"
else # else greet g'even
	greet="Good Evening, $(whoami)"
fi

# display greet
echo -e "${greet}\n"
}

# call greeting function
greeting

# \e[<fg_bg>;5;<ANSI_color_code>m ## Format for printing color background (48) and text (38)
#yellow_txt=\e[38;5;190m
#reset_bkg_text=\e[0m

# info function
myInfo() {
date_time=$(date +'%F %r')
array_list=("PATH:" "PWD:" "USER:" "DATE/TIME:")
array_info=("$PATH" "$PWD" "$(whoami)" "$date_time") # I use (whoami) because it works on Linux and Git Bash for Windows
for ((i = 0; i < ${#array_list[@]}; ++i)); do
	printf "\e[38;5;190m${array_list[$i]}\n\e[0m ${array_info[$i]}\n\n";
done
}

# call info function
myInfo














# function to say hello world

hello() {
echo "hello world"
}
hello