#!/bin/bash
if [ $# -ne 5 ]; then
 echo "error.. need args"
 echo "command:$0 <VCF> <Chr> <Pop> <Out> <threads>"
 exit 1
fi
VCF=$1
Chr=$2
Pop=$3
Out=$4
Threads=$5
vcftools --gzvcf ${VCF} --chr ${Chr} --recode --out ${Chr}
Sites=$[`grep -v "#" ${Chr}.recode.vcf|wc -l`/10]
#echo ${Sites}
SweeD-P -name ${Out} -input ${Chr}.recode.vcf -grid ${Sites} -folded -sampleList ${Pop} -threads ${Threads}
