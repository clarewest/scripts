#!/usr/bin/bash
rm contact_orders.out
for PDB in $(cat $1)
do 
echo $PDB
~/Project/Scripts/contact_order.py "$PDB"/"$PDB".proxy_map >> contact_orders.out
done
echo "Scores done."

./compare_CO.R
chmod ugo+rx ~/pub_html/Saulo/*
echo "Plots done."



