for PDB in $(cat $1)
do
echo "$PDB"
nohup /data/icarus/oliveira/Flib/pipeline.sh "$PDB" > $PDB.nohup.out 2>&1&
done

