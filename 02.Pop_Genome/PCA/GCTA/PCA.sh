#! /bin/bash
# PCA
gcta="/home/software/gcta_1.92.3beta3/gcta64"
if [ $# -ne 4 ]; then
   echo "error.. need args"
   echo "command: bash $0 <bfile> <autosome> <pca> <outprefix>"
   exit 1
fi

bfile=$1
autosome=$2
pca=$3
out=$4
 
## make germ
$gcta --bfile $bfile --make-grm --autosome-num $autosome --out ${out}.gcta
## PCA
$gcta --grm ${out}.gcta --pca $pca --out ${out}.gcta.out
