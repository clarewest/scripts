#!/bin/bash

export SAINT2=/homes/west/Project/homes/oliveira/saint2_orig/
read OUTPUT;
DATA_PATH="/data/cockatrice/west/Start2Fold/Proteins/"

### RUN SAINT2 AND STORE THE DECOY GENERATED ON THE VARIABLE "$FILE" ###
FILE=`$SAINT2/scripts/run_cotrans2 1 $OUTPUT n $DATA_PATH/$OUTPUT.fasta.txt $DATA_PATH/$OUTPUT.flib 10000 1000 2.5 linear`


### RETRIEVE THE LENGTH OF THE TARGET "$OUTPUT" ###
#LENGTH=$(cat $DATA_PATH/$OUTPUT.length)

### GET THE SCORES OF THE FINAL DECOY THAT HAS BEEN GENERATED ###
TM=$($SAINT2/3rdparty/TMalign $OUTPUT_c_n*flib_1*/"$FILE" $DATA_PATH/$OUTPUT.pdb | grep -m 1 TM-score= | awk '{ printf "%f",$2; }')
$SAINT2/bin/saint2 $DATA_PATH/config_"$OUTPUT"_c_n* -- "$OUTPUT"_c_n*flib_1*/"$FILE" > $OUTPUT.temp$$
if [ "$?" = "0" ]; then
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
        if [ -n "$TM" ]; then
                   echo $TM $FILE $SOLV $ORIE $RAPDF $LJ $CORE $PREDSS $SAULO $RG $DIAM $TORSION $COMB >> $OUTPUT.scores_final.txt
	fi
fi
 
rm $OUTPUT.temp$$

DIR=`echo "$FILE" | awk -F "_s" '{print $1}'`
for I in $(ls "$DIR"/"$FILE"_*)
do
    echo "##### $I" >> "$DIR"/"$FILE"_intermediates;
    cat $I >> "$DIR"/"$FILE"_intermediates;
    rm $I;
done

for S in $(ls "$DIR"/scmatrix_*"$FILE"*)
do
    echo "# $S" >> "$DIR"/"$FILE"_scmatrices;
    cat $S >> "$DIR"/"$FILE"_scmatrices;
    rm $S;
done

# IN VITRO
FILE=`$SAINT2/scripts/run_invitro2 1 $OUTPUT $DATA_PATH/$OUTPUT.fasta.txt $DATA_PATH/$OUTPUT.flib 11000 2.5` 
TM=$($SAINT2/3rdparty/TMalign $OUTPUT_i*flib_1*/"$FILE" $DATA_PATH/$OUTPUT.pdb | grep -m 1 TM-score= | awk '{ printf "%f",$2; }')
$SAINT2/bin/saint2 $DATA_PATH/config_"$OUTPUT"_i* -- "$OUTPUT"_i*flib_1*/"$FILE" > $OUTPUT.temp$$
if [ "$?" = "0" ]; then
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
        if [ -n "$TM" ]; then
                echo $TM $FILE $SOLV $ORIE $RAPDF $LJ $CORE $PREDSS $SAULO $RG $DIAM $TORSION $COMB >> $OUTPUT.scores_invitro.txt
        fi 
fi
rm $OUTPUT.temp$$

# REVERSE
FILE=`$SAINT2/scripts/run_cotrans2 1 $OUTPUT r $DATA_PATH/$OUTPUT.fasta.txt $DATA_PATH//$OUTPUT.flib 10000 1000 2.5 linear`
TM=$($SAINT2/3rdparty/TMalign $OUTPUT_c_r*flib_1*/"$FILE" $DATA_PATH/$OUTPUT.pdb | grep -m 1 TM-score= | awk '{ printf "%f",$2; }')
$SAINT2/bin/saint2 $DATA_PATH/config_"$OUTPUT"_c_r* -- "$OUTPUT"_c_r_*flib_1*/"$FILE" > $OUTPUT.temp$$
if [ "$?" = "0" ]; then
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
        if [ -n "$TM" ]; then
                echo $TM $FILE $SOLV $ORIE $RAPDF $LJ $CORE $PREDSS $SAULO $RG $DIAM $TORSION $COMB >> $OUTPUT.scores_reverse.txt
        fi 
fi
rm $OUTPUT.temp$$

DIR=`echo "$FILE" | awk -F "_s" '{print $1}'`

for I in $(ls "$DIR"/"$FILE"_*)
do
    echo "##### $I" >> "$DIR"/"$FILE"_intermediates;
    cat "$I" >> "$DIR"/"$FILE"_intermediates;
    rm "$I";
done

for S in $(ls "$DIR"/scmatrix_*"$FILE"*)
do
    echo "# $S" >> "$DIR"/"$FILE"_scmatrices;
    cat "$S" >> "$DIR"/"$FILE"_scmatrices;
    rm "$S";
done

