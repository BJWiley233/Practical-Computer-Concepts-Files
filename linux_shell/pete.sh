
declare -A playernames
playernames=( [RR]="Red Rolfe" [JG]="Joe Gordon" [JD]="Joe DiMaggio" [BD]="Bill Dickey" )
bases=( "home plate" "first base" "second base" "third base" )

if [[ ${#2} -gt 1 ]]; then 
	echo wrong base entered but ${playernames[${1^^}]} is on/at ${bases[2]}
elif [[ $# != 2 ]]; then
	echo not enough parameters
elif [[ ! ${bases[$2]} ]]; then
	echo you entered a wrong base but whats up "${playernames[${1^^}]}"
else 
	echo "${playernames[${1^^}]} is on/at ${bases[$2]}"
fi
