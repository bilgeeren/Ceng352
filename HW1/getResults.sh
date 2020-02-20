#!/bin/bash
echo "This script will write the query results in outputs directory. Please create the directory before using it."
echo "Please start and end values: (if you want to run just 1 query enter the number of query for both start and end)"
read startQ
read endQ
if [ $endQ -ge $startQ ] && [ $endQ -le 15 ] && [ $startQ -ge 1 ];
then
	for counter in $(seq $startQ $endQ);
	do
    if [ -f outputs/q${counter}.txt ]
    then
        rm -rfv outputs/q${counter}.txt | wc -l
    fi
	psql -f q${counter}.sql ceng352_flight_data >> outputs/q${counter}.txt
	done
	echo "See Your Output Files"
else
	echo "wrong start and end try again"
fi

# Tesekkurler bebek script.
