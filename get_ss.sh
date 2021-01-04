#!/bin/bash

## Make verbose output
if [ "$1" == "v" ]; then
	TARGET=$2
	~/bin/dssp-2.0.4-linux-amd64 -i "$TARGET".pdb -o "$TARGET".dssp	
	sed -e '1,/RESIDUE AA STRUCTURE/d' "$TARGET".dssp | cut -c 1-17 | sed -e 's/[ ]$/C/' | awk '{print $2, $5}' | sed 's/[GI]/H/g' | sed 's/[TS]/C/g' | sed 's/E/B/g'> "$TARGET".long.dssp 
else
	TARGET=$1
	~/bin/dssp-2.0.4-linux-amd64 -i "$TARGET".pdb -o "$TARGET".dssp.all	
#	sed -e '1,/RESIDUE AA STRUCTURE/d' "$TARGET".dssp | cut -c 17 | sed -e 's/[ ]/C/' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' |  awk 'BEGIN {FS="";} {for (i=1;i<=NF;i++) {if ( $i=="G" || $i=="I" ) print i " H"; else if ( $i == "E" ) print i " B"; else print i" "$i}}'
	#sed -e '1,/RESIDUE AA STRUCTURE/d' "$TARGET".dssp.all | cut -c 17 | sed -e 's/[ ]/C/' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' | sed 's/[GI]/H/g' | sed 's/[TS]/C/g' | sed 's/E/B/g'> "$TARGET".dssp
	sed -e '1,/RESIDUE AA STRUCTURE/d' "$TARGET".dssp.all | grep -v "!" | cut -c8-11,17 | sed -e 's/[[:space:]] $/ C/' | sed 's/[GI]/H/g' | sed 's/[TS]/C/g' | sed 's/[B]/E/g' > "$TARGET".dssp
fi

