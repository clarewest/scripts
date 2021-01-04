for I in $(cat $1)
do 
    PREC1=$(python ../calculate_contact_precision.py $I.metapsicov_stage1);
    PREC2=$(python ../calculate_contact_precision.py $I.metapsicov_stage2 | awk '{print $2,$3,$4,$5,$6,$7}');
    PREC3=$(python ../calculate_contact_precision.py $I.metapsicov_stage3 | awk '{print $2,$3,$4,$5,$6,$7}'); 
    echo $PREC1 $PREC2 $PREC3
done
