#!/usr/bin/env bash

####################################################################################
# Brian Wiley
# Assignment 4: Conditionals
# Define color of fox and dog and print with that color background
<<COMMENT
	Checks if files exists and if so prints out contents with cat
COMMENT
####################################################################################

<<COMMENT
# check is passwd file exist and prints contents
file="/etc/passwd"
if [[ -f $file ]]; then
	echo -e "\nContents of $file are:\n"
	cat "$file"
else 
	echo -e No \'${file}\' file exists!
fi

# check is shadow file exist and prints contents
file="/etc/shadow"
if [[ -f $file ]]; then
	echo -e "\nContents of $file are:\n"
	cat "$file" || sudo cat "$file"
else 
	echo -e No \'${file}\' file exists!
fi



#END
COMMENT

file_passwd="/etc/passwd"
file_shadow="/etc/shadow"

#yellow_txt=\e[38;5;190m
#reset_bkg_text=\e[0m

# check is passwd and shadow files exist and prints contents
if [[ -f $file_passwd ]] && [[ -f $file_shadow ]]; then
	echo -e "\n\e[38;5;190mContents of $file_passwd are:\n\e[0m"
	cat "$file_passwd" || sudo cat "$file_passwd"
	echo -e "\n\e[38;5;190mContents of $file_shadow are:\n\e[0m"
	cat "$file_shadow" || sudo cat "$file_shadow"
else 
	echo -e Both \'${file_passwd}\' and \'${file_shadow}\' files don\'t exists!
fi

# END