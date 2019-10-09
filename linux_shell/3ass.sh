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

states=("AL" "AK" "AZ" "AR" "CA" "CO" "CT" "DE" "FL" "GA" "HI" "ID" 
	"IL" "IN" "IA" "KS" "KY" "LA" "ME" "MD" "MA" "MI" "MN" "MS" 
	"MO" "MT" "NE" "NV" "NH" "NJ" "NM" "NY" "NC" "ND" "OH" "OK" 
	"OR" "PA" "PR" "RI" "SC" "SD" "TN" "TX" "UT" "VT" "VA" "WA" 
	"WV" "WI" "WY")

eastern=("CT DE FL GA IN KY ME MD MA MI NH NJ NY NC OH PA RI SC VT VA WV")
central=("AL AR IL IA KS LA MN MS MO NE ND OK SD TN TX WI")
mountain=("AZ CO ID MT NM UT WY")
western=("CA NV OR WA")


echo -e "\nToday is $(date +'%A, %F') and the time is $(TZ=":US/Mountain" date +'%I:%M:%S %p %Z') in Arizona.\n"

read -rp "Were you born in the United States[Y/N]? Press [q/Q] anytime to quit.$(echo $'\n> ')" varUS
	
while [[ ! "$varUS" =~ ^[yYnNqQ]$ ]]
do
	read  -rp "That is not a valid choice! Select [Y/N] or press [q/Q] to quit.$(echo $'\n> ')" varUS
done

if  [[ "$varUS" =~ [yY]$ ]]
then
	read -rp "Which state were you born in? Enter two letter abbreviation only.$(echo $'\n> ')" state_entry
		while [[ ! ${states[@]} =~ (^| )"${state_entry^^}"($| ) ]] && [[ ! "$state_entry" =~ ^[qQ]$ ]]
		do
			read -rp "Invalid state abbreviation! Please enter valid state.$(echo $'\n> ')" state_entry
		done 
		if [[ "$state_entry" =~ ^[qQ]$ ]]
		then
			exit
		fi
elif [[ "$varUS" =~ [nN]$ ]]
then
	read -rp "Which country were you born in?$(echo $'\n> ')" country 
		if [[ "$country" =~ ^[qQ]$ ]]
		then
			exit
		fi
else
	exit
fi

read -rp "Great!  Now tell me your date of birth.  Month and day only (MM/DD). We don't need to know how old you are :)$(echo $'\n> ')" dob
while (! (date -d "${dob:0:2}/${dob:3:5}" &> /dev/null) && [ "$dob" != "02/29" ] && ! [[ "$dob" =~ ^[qQ]$ ]])
do
	read -rp "Invalid date/format! Enter valid date (MM/DD) or press [q/Q] to quit.$(echo $'\n> ')" dob
	if [[ "$dob" =~ ^[qQ]$ ]]
	then 
		exit
	fi
done


if [[ "${varUS^^}" = "N" ]]
then 
	if [[ "${country^^}" = "MEXICO" ]]
	then
		echo -e "Welcome to the United States and to Arizona!  You did not travel too far.\n"
	else 
		echo -e "Welcome to the United States and to Arizona!  You have traveled very far from home.\n"
	fi
else
	if [[ $"AZ" =~ (^| )"${state_entry^^}"($| ) ]]
	then
		echo -e "An Arizonian! Awesome! Born and raised.\n"
	elif [[ $"HI AK" =~ (^| )"${state_entry^^}"($| ) ]]
	then 
		echo -e "Welcome to Arizona! You have traveled far from a non-continental state.\n"
	elif [[ $eastern =~ (^| )"${state_entry^^}"($| ) ]]
	then
		echo -e "Welcome to Arizona! You have traveled far the eastern US.\n"
	elif [[ $central =~ (^| )"${state_entry^^}"($| ) ]]
	then
		echo -e "Welcome to Arizona! You have traveled pretty far the central US.\n"
	elif [[ $mountain =~ (^| )"${state_entry^^}"($| ) ]]
	then
		echo -e "Welcome to Arizona! You have may have traveled pretty far but you liked this timezone.\n"
	else
		echo -e "Welcome to Arizona! You have may have traveled pretty far from the western US.\n"
	fi
fi


if [[ $(date -d "$dob" +'%Y%m%d') -eq $(date -d "00:00" +'%Y%m%d') ]]
then
	echo -e "Happy Birthday! What are you doing in class you overacheiver?!\n"
elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -eq 1 ] &&
	 [[ $(date -d $dob +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]]
then 
	echo -e "Your birthday is tomorrow! Are you excited\n"
elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -lt 60 ] &&
	 [[ $(date -d "$dob" +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]]	
then
	days=$(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) ))
	echo -e "Your birthday is coming soon in $days days! I hope you've made plans.\n"
elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -lt 60 ] &&
	 [[ $(date -d "$dob" +'%Y%m%d') -lt $(date -d "00:00" +'%Y%m%d') ]]
then 
	days=$(expr $(( (`date -d "12/31" +%s` - `date -d "00:00" +%s`) / (24*3600) )) + \
				$(( (`date -d "$dob" +%s` - `date -d "01/01" +%s`) / (24*3600) )) + 1)
	echo -e "Your birthday has recently past.  Your next birthday is not for $days days.\n"
elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -gt 305 ] &&
	 [[ $(date -d "$dob" +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]]
then
	days=$(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) ))
	echo -e "Your birthday has recently past.  Your next birthday is not for $days days.\n"
elif [[ $(date -d "$dob" +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]]
then
	days=$(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) ))
	echo -e "Your next birthday is not for $days days.\n"
else
	days=$(expr $(( (`date -d "12/31" +%s` - `date -d "00:00" +%s`) / (24*3600) )) + \
				$(( (`date -d "$dob" +%s` - `date -d "01/01" +%s`) / (24*3600) )) + 1)
	echo -e "Your birthday has recently past.  Your next birthday is not for $days days.\n"
fi	
		
#END