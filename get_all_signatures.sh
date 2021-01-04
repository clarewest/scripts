for PDB in $(ls)
  do
#    cd $PDB
    PDB=${PDB:0:7}
    c=${PDB:5:1}
    chain=`echo "$c" | tr '[:lower:]' '[:upper:]'`
#    if [[ "$PDB" == *"_"* ]]
#      then
#      chain=${PDB:5:1}
#    else
#      chain="A"
#    fi
#    if [ $chain = "N" -o $chain = "C" ]
#      then
#        chain="A"
#    fi
#    echo $PDB $chain
    PDB_lc=`echo "${PDB:1:4}" | tr '[:upper:]' '[:lower:]'`;
#    sed -e '1,/RESIDUE AA STRUCTURE/d' /users/oliveira/DSSP/$PDB_lc.dssp | awk '$3 == "'$chain'" {print}' | cut -c 17 | sed -e 's/[ ]/C/' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > "$PDB".dssp;
    ~/Project/Scripts/get_signatures_from_pdb.py "$PDB".pdb "$chain" 8.0 4; 
#    cat "$PDB".co >> /data/cockatrice/west/new_smallset_co.out
    cat "$PDB".sig >> /data/cockatrice/west/NewDomains/scope_smallset_sig.out
#    cat "$PDB".sig.trimmed >> /data/cockatrice/west/new_smallset_sig.trimmed.out
#    cd ..
done



