#!/usr/bin/env bash

####################################################################################
# Brian Wiley
# Assignment 13: awk
# Prints Lastname, Firstname
####################################################################################

# I like the first one better for printing all but last column for first names(s)
# https://www.unix.com/shell-programming-and-scripting/164205-awk-print-all-fields-except-last-field.html

awk '{printf $NF}; {printf ", "}; {$NF=""}1' twain.txt > lastFirst.txt