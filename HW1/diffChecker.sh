#!/bin/bash
isDifferent=false
for counter in $(seq 1 15);
do	
	DIFF=$(diff outputs/q${counter}.txt outputs_other/q${counter}.txt) 
	if [ "$DIFF" != "" ] 
	then
	    echo " Query Result --$counter-- is different."
	    isDifferent=true
	fi
	
done
if [ $isDifferent = false ]; then
	echo " All query results are same."
fi