input2="./Scrapper_Filtered_IPS"
rm Scrapper_Tabbed
rm Scrapper_Filtered

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
		 		# echo "$line" >> deleted_ips
				sed -i "/$ip/d" ./Scrapper_Filtered_IPS
		 		flag=flase
				fi
		done

done < "$input2"