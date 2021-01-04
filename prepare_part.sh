PDB=$1
SEG=$2
EXT=$3

# CONTACTS
cp $PDB.con $PDB.$EXT.con

# FLIB
python ~/Project/Scripts/split_flib_domain.py $PDB.flib $SEG
rm $PDB.d2.flib
mv $PDB.d1.flib $PDB.$EXT.flib

# FASTA.SS
awk -v SEG=$SEG '{ if ($1<=SEG) print $0}' $PDB.fasta.ss > $PDB.$EXT.fasta.ss

# FASTA.TXT
grep '>' $PDB.fasta.txt > $PDB.$EXT.fasta.txt
grep -v '>' $PDB.fasta.txt | cut -c1-"$SEG" >> $PDB.$EXT.fasta.txt 

