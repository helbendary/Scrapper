#! /bin/bash
now=$(date +"%T")
echo "Current time : $now"
#phase one
#deliminting All_Suspected_IPS 
sed -e 's/  */\t/g' All_Suspected_IPS  > Scrapper_Tabbed
input="./Scrapper_Tabbed"

#inlitrating lines and removing entry number below 2000
while IFS=' ' read -r line
do
	y=$(echo "$line" | cut -f2) 
	
	if [[ $y -gt 2000 ]]; then
		echo "$line" >> Scrapper_Filtered
	fi
done < "$input"