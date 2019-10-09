#!/usr/bin/env bash

	if [[ "$#" = 1 ]]
	then
		# if so set as array
		#set -- The quick brown fox leaped over the lazy yellow dog.
		$@ = ( $@ )
		echo $1
		
	fi
