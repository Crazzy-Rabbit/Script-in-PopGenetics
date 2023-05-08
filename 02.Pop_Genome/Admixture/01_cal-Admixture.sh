for K in 2 3 4 5 6 7 8 9 10 11 12 13 14 15; 
do /home/software/admixture_linux-1.3.0/admixture --cv QC.sample-northeast_Asia-geno005-maf003.bed $K | tee log${K}.out;
done


# CV error最小的为最佳K值
# -s 设置随机数进行自举
grep -h CV log*.out
