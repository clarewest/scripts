TARGET=$1; SEQ_FILE=$2; sed -n "/>$TARGET/,/>/ p" $SEQ_FILE | sed '${/>/d}' | sed '/^$/d'
