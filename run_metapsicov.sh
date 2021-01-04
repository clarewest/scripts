if [ $# -ne 1 ]
then
	echo -e "\nUsage:\n\n./run_metapsicov.sh List.txt\n\nList.txt could be any text file containing the 4 digit PDB codes for contact prediction, one PDB code per line.\n\n";
else
	for pdb in $(cat $1)
		do
			nohup ~/Project/Flib/pipeline.sh $pdb > $pdb.conhup.out 2>&1&
		done
fi
