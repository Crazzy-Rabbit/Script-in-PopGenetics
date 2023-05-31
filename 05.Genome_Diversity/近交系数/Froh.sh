#! /bin/bash

Rscript="/home/sll/miniconda3/envs/python3.7/lib/R/bin/Rscript"
if [ $# -ne 3 ]; then
  echo "Error! need args"
  echo "command: bash $0 <vcf vcf文件> <chr 最大染色体号> <Lauto 常染色体总长度>"
  exit 1
fi

vcf=$1
chr=$2
Lauto=$3

mkdir chr
cd chr
for ((i=1; i<=$chr; i++));
do
  vcftools --vcf $vcf --LROH --chr $i --out chr.$i
done

# FNR > 1，所有文件从第二行读，NR == 1只输出第一个文件的第一行
awk 'FNR > 1 || NR == 1' *.LROH > ../all.chr.LROH
cd ..

touch stat_Froh.r
cat stat_Froh.r <<EOF
a = read.table("all.chr.LROH", header=TRUE)
cha = a[,3]-a[,2]
jishu = aggregate(cha, by=list(a[,8]), length)
zc = aggregate(cha, by=list(a[,8]), sum)
aa = data.frame(jishu, zc)
write.table(aa, "IDIV_LROH.txt", col.names=F, row.names=F, quote=F, sep="\t")
EOF

Rscript stat_Froh.r

awk -v L=$Lauto '{print $1"\t"$4"\t"$4/L}' IDIV_LROH.txt > Froh.txt
