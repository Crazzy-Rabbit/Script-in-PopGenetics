#! /bin/bash

if [ $# -ne 7 ]; then
    echo "command:  bash $0 <bfile> <chr> <geno> <maf> <winsize> <step> <R2>"
    echo "bfile:    二进制plink格式文件的前缀"
    echo "chr：     物种染色体条数"
    echo "geno:     缺失率大于这个值的过滤，一般为0.05或0.1"
    echo "maf:      最小等位基因频率小于这个值的过滤，一般为0.03"
    echo "winsize:  窗口大小，单位为Kb"
    echo "step:     步长大小，单位为Kb"
    echo "R2:       R2阈值"
    echo "maf可以设置为所有样品中每个位点最少存在3个等位的突变"
    echo "一般我们设置后三个参数为 50 25 0.2"
    exit 1
fi
bfile=$1
chr=$2
geno=$3
maf=$4
win=$5
step=$6
r=$7

# 过滤geno和maf
plink --allow-extra-chr --chr-set $chr \
      -bfile $bfile \
      --geno $geno --maf $maf \
      --make-bed --out QC.${bfile}

# 过滤LD
# 转为map、ped格式
plink --allow-extra-chr --chr-set $chr \
      -bfile QC.$bfile \
      --recode \
      --out QC.${bfile}
# 填充map文件第二列，
awk -F '\t' '{print $1"\t"$1":"$4"\t"$3"\t"$4}' QC.${bfile}.map > QC.${bfile}.correction.map
# 删除原来的map文件, 将生成的map文件改为原来的map文件名称
rm QC.${bfile}.map

mv QC.${bfile}.correction.map QC.${bfile}.map

#转为二进制格式
plink --allow-extra-chr --chr-set $chr \
      --file QC.${bfile} \
      --make-bed \
      --out QC.${bfile}
#进行LD过滤
plink --allow-extra-chr --chr-set $chr \
      -bfile QC.${bfile}  \
      --indep-pairwise $win $step $r \
      --out QC.ld.${bfile}-502502

plink --allow-extra-chr --chr-set $chr \
      -bfile QC.${bfile} \
      --extract QC.ld.${bfile}-502502.prune.in \
      --make-bed \
      --out QC.ld.${bfile}-502502
