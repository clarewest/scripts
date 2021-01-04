for pdb in $(echo 2DN2_A)
	do
		cd $pdb
		for method in $(echo final reverse invitro)
			do
				sort -r "$pdb".scores_"$method".txt | head -n 1 >> /data/cockatrice/west/"$pdb"_models.txt
			done
		cd /data/cockatrice/west/CTF
	done
				
				 	
