#!/bin/bash
INPUT=$1
OUTPUT=`echo $INPUT | cut -d "_" -f 1`
CHAIN=`echo $INPUT | cut -d "_" -f 2`
S_CHUNK=`echo $INPUT | cut -d "_" -f 3`
F_CHUNK=`echo $INPUT | cut -d "_" -f 4 | cut -d "." -f 1`


$SAINT2/bin/saint2 ~/Project/Scripts/config_1G6P*_c_n_1G6P.flib_10000_1000_t2.5_linear -- $INPUT > $OUTPUT.temp$$
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

#                   echo $S_CHUNK $F_CHUNK $COMB >> "$OUTPUT"_"$CHAIN".scores_final_2.txt
	#fi
#fi
rm $OUTPUT.temp$$
echo -n $COMB
