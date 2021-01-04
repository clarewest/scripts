PDB=$1
RESOLUTION=$(grep "REMARK   2 RESOLUTION." "$PDB".pdb | awk '{ print $4 }')
echo $PDB $RESOLUTION
