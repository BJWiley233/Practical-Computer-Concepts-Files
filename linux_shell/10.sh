#!/bin/bash
# Bash Menu Script Example

PS3='Please enter your choice: '


	select i in "German" "English" "Spanish" "Quit"
	  do
        if [[ "$i" = "German" ]]
        then echo "Guten Tag"
        break
        elif [[ "$i" = "English" ]]
        then echo "Hello"
        break
        elif [[ "$i" = "Spanish" ]]
        then echo "Holla"
        break
        elif [[ "$i" = "Quit" ]]
        then
        exit 
	fi
	done

