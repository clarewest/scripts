PDB=$1
for DECOY in $(cat $PDB.lst); do AVPROQLOCAL=$(for RESIDUE in $(cut -c24-27 $PDB/$DECOY.cut | uniq | wc -l); do RESN=$(( RESIDUE - 1 )); sed -n "$RESN"p ProQ3D_$PDB/$DECOY.pdb.proq3.local; done | awk '{ sum += $4 } END { if (NR > 0) print sum / NR }'); echo $PDB $DECOY $AVPROQLOCAL; done
