for I in $(cat $1)
do 
    PREC1=$(python ../calculate_SS_precision.py $I.dssp_ss $I.psipred_ss);
    PREC2=$(python ../calculate_SS_precision.py $I.dssp_ss $I.psipred_ss2);
    PREC3=$(python ../calculate_SS_precision.py $I.dssp_ss $I.spd3_ss); 
    echo $I $PREC1 $PREC2 $PREC3
done
