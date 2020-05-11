input2="./Scrapper_Filtered_IPS"
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