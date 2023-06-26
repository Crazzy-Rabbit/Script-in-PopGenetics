#! /bin/bash
# @Author: Lulu Shi
# @Email: crazzy_rabbit@163.com

########################################################
# 进行geno maf 及 LD过滤
# 输入文件可以为vcf，也可以为bed等plink二进制文件，全名
# LD默认的过滤参数 50 25 0.2， 若想设置别的，记得修改
########################################################
if [[ $# -ne 5 ]]; then
    echo "error need args!"
    echo "input file can vcf or bim (all full name)"
    echo "Usage: bash $0 <file> <chr> <geno> <maf> <out>"
    exit 1
fi

file=$1
chr=$2
geno=$3
maf=$4
out=$5

# Check if the input file is vcf file, to geno and maf
if [[ "${file##*.}" = "vcf" ]]; then
  plink --allow-extra-chr --chr-set $chr -vcf $file --double-id --geno $geno --maf $maf --make-bed --out $out
else
  plink --allow-extra-chr --chr-set $chr -bfile $file --geno $geno --maf $maf --make-bed --out $out
fi

# LD filter
plink --allow-extra-chr --chr-set $chr -bfile $out --set-missing-var-ids @:# --indep-pairwise 50 25 0.2 --out $out-ld502502
plink --allow-extra-chr --chr-set $chr -bfile $out --set-missing-var-ids @:# --extract $out-ld502502.prune.in --make-bed --out $out-ld502502
