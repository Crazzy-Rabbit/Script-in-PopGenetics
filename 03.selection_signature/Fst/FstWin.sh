#! /bin/bash

if [ $# -ne 6 ]; then
 echo "error.. need args"
 echo "command:$0 <VCF> <Pop1> <Pop2> <Win> <Step> <Out>"
 exit 1
fi
VCF=$1
Pop1=$2
Pop2=$3
Win=$4
Step=$5
Out=$6

if [[ "${file##*.}" = "vcf.gz" ]]; then
  vcftools --gzvcf ${VCF} --weir-fst-pop ${Pop1} --weir-fst-pop ${Pop2} --fst-window-size ${Win} --fst-window-step ${Step} --out ${Out} --max-missing 0.9 --maf 0.05
else
  vcftools --vcf ${VCF} --weir-fst-pop ${Pop1} --weir-fst-pop ${Pop2} --fst-window-size ${Win} --fst-window-step ${Step} --out ${Out} --max-missing 0.9 --maf 0.05
fi
