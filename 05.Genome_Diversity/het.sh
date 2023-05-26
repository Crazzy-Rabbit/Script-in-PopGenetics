for i in Ch_D_T Fe_D_T Fe_W_T Ru_W_T;
do
plink --allow-extra-chr --chr-set 35 --bfile ../QC.22_reindeer.snp_pass.nchr --keep ${i}.txt --het --out ${i}

cat ${i}.het|awk '{sum+=$6} END {print "'"${i}"'", sum/NR}' > ${i}.f

done

cat *f > Fhom.txt