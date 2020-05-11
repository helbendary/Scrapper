#phase two
#removing specific host names
sed -i '/tedata/d' ./Scrapper_Filtered

#Filtering fields to work on
less Scrapper_Filtered| cut -f1,2,3 > Scrapper_Filtered_IPS