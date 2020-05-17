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

#phase two
#removing specific host names

sed -i '/tedata/d' ./Scrapper_Filtered
sed -i '/etisalat/d' ./Scrapper_Filtered

#Filtering fields to work on

less Scrapper_Filtered| cut -f1,2,3 > Scrapper_Filtered_IPS
rm Scrapper_Tabbed
rm Scrapper_Filtered
input2="./Scrapper_Filtered_IPS"

#phase three
#ip= IP addr, log= the log for specific IP, crud= HTTP Methods , path= path of the entry

while IFS=' ' read -r line
	do
		ip=$(echo "$line" | cut -f3) 
		log=$(grep  $ip elcinema-web_production-ssl.access.log)
		path=$(echo "$log" |cut -d' ' -f7| tail -n 15)
		flag=true
		
# phase four	
# removing all ip with /hits path 

		for n in $path
			do	
				if  [[ "$n" == *"/hits"* ]] && [[ $flag == true ]] ; then
				sed -i "/$ip/d" ./Scrapper_Filtered_IPS
		 		flag=flase
				fi
		done
done < "$input2"

# collecting scrappers whith CRUD methods that are more than five times in row
 
while IFS=' ' read -r line
	do
		ip=$(echo "$line" | cut -f3) 
		log=$(grep  $ip elcinema-web_production-ssl.access.log)
		crud=$(echo "$log" |cut -d' ' -f6| tail -n 15)
 		counter_GET=0
		counter_POST=0
		counter_PATCH=0	
		flag_GET=flase
		flag_POST=flase
		flag_PATCH=flase

  		for n in $crud
			do
				#GET check
				if [[ $flag_GET == flase ]]; then
					if [[ $n == '"GET'  ]]; then
						((counter_GET ++))
					else
						counter_GET=0
					fi

					if [[ $counter_GET -ge 5 ]]; then
						echo "$line" >> Scrapper_Final_GET
						flag_GET=true
					fi
				fi
				#POST check
				if [[ $flag_POST == flase ]]; then
					if [[ $n == '"POST' ]]; then
						((counter_POST ++))
					else
						counter_POST=0
					fi

					if [[ $counter_POST == 5 ]]; then
						echo "$line" >> Scrapper_Final_POST
						flag_POST=true
					fi
				fi
				#PATCH check
				if [[ $flag_PATCH == flase ]]; then
					if [[ $n == '"PATCH' ]]; then
						((counter_PATCH ++))
					else
						counter_PATCH=0
					fi

					if [[ $counter_PATCH == 5 ]]; then
						echo "$line" >> Scrapper_Final_PATCH
						flag_PATCH=true
					fi
				fi
		done
done < "$input2"
rm Scrapper_Filtered_IPS
echo "Done"
now=$(date +"%T")
echo "Current time : $now"