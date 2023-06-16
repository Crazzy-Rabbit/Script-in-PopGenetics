#! /bin/bash
# @Author: Lulu Shi
# @Mails: crazzy_rabbit@163.com

if [ $# -ne 3 ]; then
 echo "error.. need args"
 echo "command: bash $0 <VCF> <Pop> <winsize>"
 exit 1
fi
SweeD="/home/ywf/software/sweed/SweeD"
VCF=$1
Pop=$2
winsize=$3

for chr in {1..29};
do
vcftools --gzvcf ${VCF} --chr ${chr} --recode --out ${chr}
Sites=$[`grep -v "#" ${chr}.recode.vcf|wc -l`/$winsize]
#echo ${Sites}
$SweeD -name $chr -input ${chr}.recode.vcf -grid ${Sites} -folded -sampleList ${Pop}
done
