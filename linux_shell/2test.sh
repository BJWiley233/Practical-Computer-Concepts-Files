#!/usr/bin/env bash

############################################
# Brian Wiley
# Assignment 2: Variables
# 1 environmental variable, 1 custom variable, 1 command substitution
<<COMMENT
	Asks user if they were born in US, if so what state, and also their DoB.
	Returns custom message and indicates how many days until birthday.
COMMENT

############################################

quit=0
invalid=0
states=("AL" "AK" "AZ" "AR" "CA" "CO" "CT" "DE" "FL" "GA" "HI" "ID" 
	"IL" "IN" "IA" "KS" "KY" "LA" "ME" "MD" "MA" "MI" "MN" "MS" 
	"MO" "MT" "NE" "NV" "NH" "NJ" "NM" "NY" "NC" "ND" "OH" "OK" 
	"OR" "PA" "PR" "RI" "SC" "SD" "TN" "TX" "UT" "VT" "VA" "WA" 
	"WV" "WI" "WY")


echo -e "\nToday is $(date +'%A, %F') and the time is $(TZ=":US/Mountain" date +'%I:%M:%S %p %Z') in Arizona.\n"

while [ "$quit" -eq 0 ]
do 
	read -rp "Were you born in the United States[Y/N]? Press [q/Q] anytime to quit.$(echo $'\n> ')" varUS
	case "$varUS" in
		y|Y ) read -rp "Which state were you born in? Enter two letter abbreviation only.$(echo $'\n> ')" state_entry
		while [[ ! ${states[@]} =~ (^| )"${state_entry^^}"($| ) ]] && [[ ! "$state_entry" =~ ^[qQ]$ ]]
			do
				read -rp "Invalid state abbreviation! Please enter valid state.$(echo $'\n> ')" state_entry
			done 
			if [[ "$state_entry" =~ ^[qQ]$ ]]
			then
				break
			fi;;
		n|N ) read -rp "Which country were you born in?$(echo $'\n> ')" country 
			if [[ "$country" =~ ^[qQ]$ ]]
			then
				break
			fi;;
		q|Q ) quit=1 
		break;;
		* ) while [[ ! "$varUS" =~ ^[yYnNqQ]$ ]]
				do
					read  -rp "That is not a valid choice! Select [Y/N] or press [q/Q] to quit.$(echo $'\n> ')" varUS
			done
			if [[ "$varUS" =~ ^[qQ]$ ]]
			then
				break
			fi;;
	esac
	read -rp "Great!  Now tell me your date of birth.  Month and day only (MM/DD). We don't need to know how old you are :)$(echo $'\n> ')" dob
	while (! (date -d "${dob:0:2}/${dob:3:5}" &> /dev/null) && [ "$dob" != "02/29" ] && ! [[ "$dob" =~ ^[qQ]$ ]])
	do
		read -rp "Invalid date/format! Enter valid date or press [q/Q] to quit.$(echo $'\n> ')" dob
		if [[ "$dob" =~ ^[qQ]$ ]]
		then 
			quit=1
			break
		fi
	done
	quit=1
done

if [[ "${varUS^^}" = "N" ]]
then 
	if [[ "${country^^}" = "MEXICO" ]]
	then
		echo -e "Welcome to the United States and to Arizona.  You did not travel too far.\n"
		if [[ $(date -d "$dob" +'%Y%m%d') -eq $(date -d "00:00" +'%Y%m%d') ]]
		then
			echo "Happy Birthday! What are you doing in class you overacheiver?!"
		elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -eq 1 ] &&
			 [[ $(date -d $dob +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]]
		then 
			echo "Your birthday is tomorrow! Are you excited"
		elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -lt 60 ] &&
			 [[ $(date -d "$dob" +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]]	
		then
			days=$(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) ))
			echo "Your birthday is coming soon in $days days! I hope you've made plans."
		elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -lt 60 ] &&
		     [[ $(date -d "$dob" +'%Y%m%d') -lt $(date -d "00:00" +'%Y%m%d') ]]
		then 
			days=$(expr $(( (`date -d "12/31" +%s` - `date -d "00:00" +%s`) / (24*3600) )) + \
	                    $(( (`date -d "$dob" +%s` - `date -d "01/01" +%s`) / (24*3600) )) + 1)
			echo "Your birthday has recently past.  Your next birthday is not for $days days."
		elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -gt 305 ] &&
			 [[ $(date -d "$dob" +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]]
		then
			days=$(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) ))
			echo "Your birthday has recently past.  Your next birthday is not for $days days."
		elif [[ $(date -d "$dob" +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]]
		then
			days=$(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) ))
			echo "Your next birthday is not for $days days."
		else
			days=$(expr $(( (`date -d "12/31" +%s` - `date -d "00:00" +%s`) / (24*3600) )) + \
	                    $(( (`date -d "$dob" +%s` - `date -d "01/01" +%s`) / (24*3600) )) + 1)
			echo "Your birthday has recently past.  Your next birthday is not for $days days."
		fi
	else 
		echo -e "Welcome to the United States and to Arizona.  You have traveled very far from home.\n"
		if [[ $(date -d $dob +'%D') -eq $(date +'%D') ]]
		then
			echo "Happy Birthday! What are you doing in class you overacheiver?!"
		else
			echo "Blah"
		fi
	fi
else
	echo US
fi	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

#END