TARGET=$1
CHAIN_TARGET=$2
DECOY_DIR=$3
DECOY=$4

TM="0.00"
TM2="0.00"

#export SAINT2=/homes/west/SAINT2/SAINT_eleanor/
export SAINT2=/homes/west/SAINT2/SAINT_laura/
export QA=/data/pegasus/not-backed-up/west/QualityAssessment/

if [ ! -f $DECOY_DIR/$DECOY.proxy_fasta ] || [ ! -f $DECOY_DIR/$DECOY.proxy_map ]
then
    $QA/bin/getcontactsSparse3.py $DECOY_DIR/$DECOY $CHAIN_TARGET 8.0 2>> $TARGET.log
fi


### Clare edit: stderror can sometimes merge with the stdout messily, leaving "True positives" in the middle of an stdout line
### I have solved this by turning off stdout buffering for this command
if [ ! -s $TARGET.metapsicov.stage1 ]; then
  PPV="-nan"
else
  PPV=$(unbuffer $QA/bin/convert $DECOY_DIR/$DECOY.proxy_fasta $TARGET.aln $TARGET.metapsicov.stage1 $DECOY_DIR/$DECOY.proxy_map 2>&1 | grep "^True Positives" | awk '{print $3}');
  if [ -z $PPV ]; then
    PPV=$(unbuffer $QA/bin/convert $DECOY_DIR/$DECOY.proxy_fasta $TARGET.aln $TARGET.metapsicov.stage1 $DECOY_DIR/$DECOY.proxy_map 2>&1 | grep "^True Positives" | awk '{print $3}');
  fi
fi

## Clare edit: we don't care about neff
Neff=$(cat $TARGET.beff);

if [ ! -f $DECOY_DIR/$DECOY.map ]
then 
   $QA/bin/parse_proxy_map $TARGET/$DECOY.proxy_map > $DECOY_DIR/$DECOY.map
fi

if [ ! -s $DECOY_DIR/$DECOY.out_map ] || [ ! -f $TARGET/$DECOY.align ]
then
    $QA/bin/map_align -a $TARGET.meta_map -b $DECOY_DIR/$DECOY.map > $DECOY_DIR/$DECOY.out_map
    tail -n 1 $DECOY_DIR/$DECOY.out_map > $DECOY_DIR/$DECOY.align
fi

if [ $(awk '{print NF}' $DECOY_DIR/$DECOY.align) -gt 9 ] 
then
    LEN=$(awk '{print $8}' $DECOY_DIR/$DECOY.align)
    FIRST=$(awk '{print $9}' $DECOY_DIR/$DECOY.align | awk -v FS=":" '{print $1}')
    FIRST2=$(awk '{print $9}' $DECOY_DIR/$DECOY.align | awk -v FS=":" '{print $2}')
    LAST=$( expr $LEN + $FIRST )
    LAST2=$( expr $LEN + $FIRST2 )
    SCORE=$(cat $DECOY_DIR/$DECOY.align | grep "^MAX" | awk '{print $5,$8}' );
else
    LEN=0
    FIRST=0
    FIRST2=0
    LAST=0
    LAST2=0
    SCORE="0.0 0"
fi

### IF MAP_ALIGN HIT IS LONG ENOUGH, CALCULATE TM-SCORE OF BEST HIT ###
# Clare edit: we no longer need to do this, TM score of hit doesn't matter
#if [ $LEN -gt 10 ]
#then
#    python $QA/bin/get_fragment.py $TARGET $CHAIN_TARGET $FIRST $LAST $DECOY_DIR/$DECOY 2> /dev/null
#    if [ "$?" = "0" ]
#    then
#        cp $DECOY_DIR/"$DECOY" $DECOY_DIR/"$DECOY".pdb
#        python $QA/bin/get_fragment.py $DECOY_DIR/$DECOY $CHAIN_TARGET $FIRST2 $LAST2 $DECOY_DIR/"$DECOY"b 2> /dev/null
#        if [ "$?" = "0" ]
#        then
#          TM=0.0
          ### CLARE COMMENT THIS IN LATER
#           TM=$($QA/bin/TMalign $DECOY_DIR/"$DECOY"_segment.pdb "$DECOY_DIR/$DECOY"b_segment.pdb | grep -m 1 "TM-score=" | awk '{ printf "%f",$2; }') 2> /dev/null
 #       fi
 #   fi
#fi

if [ -z $TM ];
then 
  TM=0.00
fi

### CALCULATE EIGENTHREADER
if [ ! -d $DECOY_DIR/TDB_DIR/ ]
then 
    mkdir $DECOY_DIR/TDB_DIR
fi
TDB_DIR=$DECOY_DIR/TDB_DIR

if [ ! -f $DECOY_DIR/$DECOY.dssp ]
then
    $QA/bin/dssp-2.0.4-linux-amd64 -i $DECOY_DIR/$DECOY > $DECOY_DIR/$DECOY.dssp
fi

if [ ! -f $DECOY_DIR/$DECOY.pdb ]
then
      cp  $DECOY_DIR/$DECOY $DECOY_DIR/$DECOY.pdb
fi

if [ ! -f $DECOY_DIR/TBD_DIR/$DECOY.eig ]
then
    $QA/bin/strsum_eigen $DECOY_DIR/$DECOY.pdb $DECOY_DIR/$DECOY.dssp $TDB_DIR/$DECOY.tdb $TDB_DIR/$DECOY.eig
fi

##
### CALCULATE THE PPV FOR THE TARGET ###
CON=$(cat $TARGET.ppv);

### CALCULATE TM-SCORE OF THE DECOY ### 
if [ -f $TARGET.pdb ];
then
  TM2=$($SAINT2/3rdparty/TMalign $DECOY_DIR/$DECOY $TARGET.pdb | grep -m 1 TM-score= | awk '{ printf "%f",$2; }')
fi

###############  COMMENT THIS IN LATER
## ScafFold:
#TM2=$($SAINT2/3rdparty/TMalign $DECOY_DIR/$DECOY.cut sampled_$TARGET.pdb | grep -m 1 TM-score= | awk '{ printf "%f",$2; }')

if [ -z $TM2 ];
then
  TM2=0.00
fi

### CALCULATE S2 SCORE ###
# Clare's edit: 
# incomplete score files can cause missing values that aren't caught
# so if the file exists (and is not empty), check they contain the right scores
# if they don't, do it again
# If the scores still don't exist, assign "NA"n
if [ -s $DECOY_DIR/"$DECOY"_scores ] 
then
    SAULO=`cat $DECOY_DIR/"$DECOY"_scores | awk '/^Saulo =/ { print $NF; }'`
    COMB=`cat $DECOY_DIR/"$DECOY"_scores | awk '/^Combined score =/ { print $NF; }'`
fi

if [ -z $COMB ]
then
    $SAINT2/bin/saint2 config_"$TARGET"* -- "$DECOY_DIR/$DECOY"  > $DECOY_DIR/"$DECOY"_scores
    SAULO=`cat $DECOY_DIR/"$DECOY"_scores | awk '/^Saulo =/ { print $NF; }'`
    COMB=`cat $DECOY_DIR/"$DECOY"_scores | awk '/^Combined score =/ { print $NF; }'`
fi

if [ -z $COMB ]
then
    SAULO="NA"
    COMB="NA"
fi

exit
### Parts to include once EigenTHREADER Pcons and PROQ3D have been run separately ###

#Saulo's format:
#EIGEN=$(grep "$DECOY" $QA/data/Training/$TARGET.out | awk '{print $1}')
#PCONS=$(grep $DECOY_DIR/$DECOY $TARGET.pcons.txt | awk '{print $2}')
#Clare's format:
if [ -f $TARGET.out ]; then
  EIGEN=$(grep -w "$DECOY" $TARGET.out | awk '{print $1}')
else EIGEN=0.00;
fi
PCONS=$(grep -w "$DECOY" $TARGET.pcons.txt | awk '{print $2}')

#exit

#PROQ=$(tail -n1 $TARGET/"$DECOY".pdb.proq3.global)
PROQ=$(tail -n1 ProQ3D_$TARGET/"$DECOY".pdb.proq3.global)
if [ -z $EIGEN ]; then
  EIGEN="NA"
fi
if [ -z $PCONS ]; then
  PCONS="NA"
fi

echo $TARGET $DECOY $PPV $SCORE $EIGEN $SAULO $COMB $CON $Neff $TM $TM2 $PCONS $PROQ;
# old order: echo $TARGET $DECOY $PPV $SCORE $EIGEN $PCONS $SAULO $COMB $CON $Neff $TM $TM2;
#echo $TARGET $DECOY PPV $PPV SCORE $SCORE EIGEN $EIGEN SAULO $SAULO COMB $COMB CON $CON Neff $Neff TMs $TM $TM2 Pcons $PCONS ProQ3D $PROQ  #| awk '{if (NF!=29) print $0}';

