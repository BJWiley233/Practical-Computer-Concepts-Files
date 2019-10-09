#!/user/bin/env bash

declare -A assoc
test=($(sed '2q;d' lonely.txt))

for i in "${test[@]}"
do
	((assoc[${i}]++))
done

for i in "${!assoc[@]}"
do 
	echo "key : $i"
	echo "value : ${assoc[$i]}"
	echo "remainder/2 : ${assoc[$i]}"
done
	