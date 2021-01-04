PDB=$1
read -a BREAKPOINTS < ~/twodomain_predcons/validationset/$PDB.sschunks
BP=`grep "$PDB" ~/twodomain_predcons/validationset/Validationset_segments.txt | cut -d " " -f 2`
echo $BP
for i in "${!BREAKPOINTS[@]}"; do
   if [[ "${BREAKPOINTS[$i]}" = "${BP}" ]]; then
       COL="${i}";
   fi
done
echo $COL
awk -v C=$COL '{print $1, $(C+1)}' "$PDB"_scores_real.txt > foldon1_TM_$PDB.txt
awk -v C=$COL '{print $1, $(C+1)}' "$PDB"_C_scores_real.txt > foldon2_TM_$PDB.txt
		
