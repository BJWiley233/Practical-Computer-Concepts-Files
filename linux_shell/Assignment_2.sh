#!/usr/bin/env bash

############################################################################
# Brian Wiley
# Assignment 2: Variables
# 1 environmental variable, 1 custom variable, 1 command substitution
<<COMMENT
	Asks user if they were born in US, if so what state, and also their DoB.
	Returns custom message and indicates how many days until birthday.
COMMENT
############################################################################

# instantiate array of states
states=("AL" "AK" "AZ" "AR" "CA" "CO" "CT" "DE" "FL" "GA" "HI" "ID" 
	"IL" "IN" "IA" "KS" "KY" "LA" "ME" "MD" "MA" "MI" "MN" "MS" 
	"MO" "MT" "NE" "NV" "NH" "NJ" "NM" "NY" "NC" "ND" "OH" "OK" 
	"OR" "PA" "PR" "RI" "SC" "SD" "TN" "TX" "UT" "VT" "VA" "WA" 
	"WV" "WI" "WY")

# instantiate arrays of different regions/timezone of country
eastern=("CT DE FL GA IN KY ME MD MA MI NH NJ NY NC OH PA RI SC VT VA WV")
central=("AL AR IL IA KS LA MN MS MO NE ND OK SD TN TX WI")
mountain=("AZ CO ID MT NM UT WY")
western=("CA NV OR WA")

# get current hour on root system (24 hour clock format i.e. 0-23)
hour=$(date +"%H")

# if it is midnight to midafternoon will say g'morn
if [ $hour -ge 0 ] && [ $hour -lt 12 ]
then
	greet="Good Morning, $(whoami)"
# if it is midafternoon to evening will say g'after
elif [ $hour -ge 12 ] && [ $hour -lt 18 ]
then
	greet="Good Afternoon, $(whoami)"
else # else greet g'even
	greet="Good Evening, $(whoami)"
fi

# display greet
echo -e "\n$greet\n"

# indicate date in dayname, YYYY-MM-DD format and print time in Arizona
echo -e "Today is $(date +'%A, %F') and the time is $(TZ=":US/Mountain" date +'%I:%M:%S %p %Z') in Arizona.\n"

# prompt entry for whether born in US
read -rp "Were you born in the United States[Y/N]? Press [q/Q] anytime to quit.$(echo $'\n> ')" varUS

# while input is not is Yes, No or quit format continue to prompt for entry or quit to exit
while [[ ! "$varUS" =~ ^[yYnNqQ]$ ]]
do
	read  -rp "That is not a valid choice! Select [Y/N] or press [q/Q] to quit.$(echo $'\n> ')" varUS
done

# if yes to US, continue to prompt for state until valid state or quit to exit
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
# if no to US =, prompt for country or quit to exit (doesn't validate country)		
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

# prompt for birthday date in MM/DD format. I can review what each of the date conditions do in class.
# https://unix.stackexchange.com/questions/193482/get-last-part-of-string-after-hyphen (inside condition 4)
# https://superuser.com/questions/807573/how-to-find-length-of-string-in-shell (outside condition 4)
read -rp "Great!  Now tell me your date of birth.  Month and day only (MM/DD). We don't need to know how old you are :)$(echo $'\n> ')" dob
while (! (date -d "${dob:0:2}/${dob:3:2}" &> /dev/null) && [ "$dob" != "02/29" ] && ! [[ "$dob" =~ ^[qQ]$ ]] ||
      [[ $(echo -n $(printf "%s\n" "${dob##*/}") | wc -m) -gt 2 ]] || [[ "${dob:2:1}" != "/" ]])
do
	read -rp "Invalid date/format! Enter valid date (MM/DD) or press [q/Q] to quit.$(echo $'\n> ')" dob
	if [[ "$dob" =~ ^[qQ]$ ]]
	then 
		exit
	fi
done

# if not from US echo different welcome statement for Mexico
if [[ "${varUS^^}" = "N" ]]
then 
	if [[ "${country^^}" = "MEXICO" ]]
	then
		echo -e "Welcome to the United States and to Arizona!  You did not travel too far.\n"
	else 
		echo -e "Welcome to the United States and to Arizona!  You have traveled very far from home.\n"
	fi
# else if from US check which region state is in and echo different statement
else
	if [[ $"AZ" =~ (^| )"${state_entry^^}"($| ) ]]
	then
		echo -e "\nAn Arizonian! Awesome! Born and raised.\n"
	elif [[ $"HI AK" =~ (^| )"${state_entry^^}"($| ) ]]
	then 
		echo -e "\nWelcome to Arizona! You have traveled far from a non-continental state.\n"
	elif [[ $eastern =~ (^| )"${state_entry^^}"($| ) ]]
	then
		echo -e "\nWelcome to Arizona! You have traveled far from the eastern US.\n"
	elif [[ $central =~ (^| )"${state_entry^^}"($| ) ]]
	then
		echo -e "\nWelcome to Arizona! You have traveled pretty far from the central US.\n"
	elif [[ $mountain =~ (^| )"${state_entry^^}"($| ) ]]
	then
		echo -e "\nWelcome to Arizona! You have may have traveled pretty far but you liked this timezone.\n"
	else
		echo -e "\nWelcome to Arizona! You have may have traveled pretty far from the western US.\n"
	fi
fi

# echo different response depending on date of birth
if [[ $(date -d "$dob" +'%Y%m%d') -eq $(date -d "00:00" +'%Y%m%d') ]] # today is date of birth
then
	echo -e "Happy Birthday! What are you doing in class you overacheiver?!\n"
elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -eq 1 ] &&
	 [[ $(date -d $dob +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]] # if dob is tomorrow
then 
	echo -e "Your birthday is tomorrow! Are you excited\n"
elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -lt 60 ] &&
	 [[ $(date -d "$dob" +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]]	# if dob is coming within 60 days & dob is after current date in calendar year 
then
	days=$(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) ))
	echo -e "Your birthday is coming soon in $days days! I hope you've made plans.\n"
elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -gt 305 ] &&
	 [[ $(date -d "$dob" +'%Y%m%d') -lt $(date -d "00:00" +'%Y%m%d') ]] # if dob is coming within 60 days & dob is before current date in calendar year
then
	days=$(expr $(( (`date -d "12/31" +%s` - `date -d "00:00" +%s`) / (24*3600) )) + \
				$(( (`date -d "$dob" +%s` - `date -d "01/01" +%s`) / (24*3600) )) + 1)
	echo -e "Your birthday is coming soon in $days days! I hope you've made plans.\n"
elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -lt 60 ] &&
	 [[ $(date -d "$dob" +'%Y%m%d') -lt $(date -d "00:00" +'%Y%m%d') ]] # if dob is passed within 60 days & dob is before current date in calendar year
then 
	days=$(expr $(( (`date -d "12/31" +%s` - `date -d "00:00" +%s`) / (24*3600) )) + \
				$(( (`date -d "$dob" +%s` - `date -d "01/01" +%s`) / (24*3600) )) + 1)
	echo -e "Your birthday has recently past.  Your next birthday is not for $days days.\n"
elif [ $(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) )) -gt 305 ] &&
	 [[ $(date -d "$dob" +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]] # if dob is passed within 60 days & dob is after current date in calendar year
then
	days=$(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) ))
	echo -e "Your birthday has recently past.  Your next birthday is not for $days days.\n"
elif [[ $(date -d "$dob" +'%Y%m%d') -gt $(date -d "00:00" +'%Y%m%d') ]] # else if dob is more than 60 days away past or future and dob is after current date in calendar year
then
	days=$(( (`date -d "$dob" +%s` - `date -d "00:00" +%s`) / (24*3600) ))
	echo -e "Your next birthday is not for $days days.\n"
else # dob is more than 60 days away past or future and dob is before current date in calendar year
	days=$(expr $(( (`date -d "12/31" +%s` - `date -d "00:00" +%s`) / (24*3600) )) + \
				$(( (`date -d "$dob" +%s` - `date -d "01/01" +%s`) / (24*3600) )) + 1)
	echo -e "Your next birthday is not for $days days.\n"
fi	
		
#END