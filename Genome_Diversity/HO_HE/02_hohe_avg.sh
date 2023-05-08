for i in Angus Holstein Simmental Shorthorn Charolais Hanwoo JPBC Mishima-Ushi Kazakh Mongolian Yanbian Wenling Brahman;
do 
  cat  ${i}.hwe|awk '{sum+=$7} END {print "'"${i}"'", sum/NR}' >  ${i}.HO;
  cat  ${i}.hwe|awk '{sum+=$8} END {print sum/NR}'  >  ${i}.HE;
done

cat *.HO > HO
cat *.HE > HE
paste HO HE > hohe.txt

sed -i 's/ /\t/g' hohe.txt
rm *.HE  *.HO HO HE
