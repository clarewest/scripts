maxjobs=40
parallelize () {
	while [ $# -gt 0 ] ; do
		jobcnt=(`jobs -p`)
		if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
			PDB=$1
			chain=${PDB:4}    
			pdb_lc=`echo "${PDB:0:4}" | tr '[:upper:]' '[:lower:]'`;
			~/Project/Scripts/get_classes_from_pdb.py "$pdb_lc" "$chain" &
			shift
		fi
	done
	wait
}

LIST=`awk '{if (NR>1) print $1}' culled_pdb.txt`
parallelize $LIST

