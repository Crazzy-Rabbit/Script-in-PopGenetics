#!/bin/bash
if [ $# -ne 4 ]; then
 echo "error.. need args"
 echo "command: bash $0 <VCF> <Pop> <Out> <winsize>"
 exit 1
fi
SweeD="/home/ywf/software/sweed/SweeD"
VCF=$1
Pop=$2
Out=$3
winsize=$4

for chr in {1..29};
do
vcftools --gzvcf ${VCF} --chr ${chr} --recode --out ${chr}
Sites=$[`grep -v "#" ${chr}.recode.vcf|wc -l`/$winsize]
#echo ${Sites}
$SweeD -name ${Out} -input ${chr}.recode.vcf -grid ${Sites} -folded -sampleList ${Pop}
done
