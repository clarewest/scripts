#!/bin/bash
INPUT=$1
OUTPUT=`echo $INPUT | cut -d "_" -f 1`
CHAIN=`echo $INPUT | cut -d "_" -f 2`
CHUNK=`echo $INPUT | cut -d "_" -f 3 | cut -d "." -f 1`


$SAINT2/bin/saint2 config_"$OUTPUT"_c_n*linear -- "$OUTPUT"_"$CHAIN"_"$CHUNK".pdb > $OUTPUT.temp$$
#if [ "$?" = "0" ]; then
        SOLV=`cat $OUTPUT.temp$$ | awk '/^Solvation =/ { print $NF; }'`
        ORIE=`cat $OUTPUT.temp$$ | awk '/^Orientation =/ { print $NF; }'`
        LJ=`cat $OUTPUT.temp$$ | awk '/^Lennard-Jones =/ { print $NF; }'`
        RAPDF=`cat $OUTPUT.temp$$ | awk '/^RAPDF =/ { print $NF; }'`
        CORE=`cat $OUTPUT.temp$$ | awk '/^CORE =/ { print $NF; }'`
        PREDSS=`cat $OUTPUT.temp$$ | awk '/^PredSS =/ { print $NF; }'`
        SAULO=`cat $OUTPUT.temp$$ | awk '/^Saulo =/ { print $NF; }'`
        COMB=`cat $OUTPUT.temp$$ | awk '/^Combined score =/ { print $NF; }'`
        RG=`cat $OUTPUT.temp$$ | awk '/^Radius of gyration =/ { print $NF; }'`
        DIAM=`cat $OUTPUT.temp$$ | awk '/^Diameter =/ { print $NF; }'`
        TORSION=`cat $OUTPUT.temp$$ | awk '/^PredTor =/ { print $NF; }'`
 #       if [ -n "$TM" ]; then
#                   echo $CHUNK $SOLV $ORIE $RAPDF $LJ $CORE $PREDSS $SAULO $RG $DIAM $TORSION $COMB >> "$OUTPUT"_"$CHAIN".scores_final.txt

                   echo $CHUNK $COMB >> "$OUTPUT"_"$CHAIN".scores_final.txt
	#fi
#fi
rm $OUTPUT.temp$$
