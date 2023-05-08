#!/bin/bash

vcf="QC.sample126.chart.filter-geno005-maf003.NC.anno.vcf"

grep -v "#" $vcf | awk '{print $1"\t"$2"\t"$4"\t"$5}' > snpEff1
grep -v "#" $vcf | awk '{print $8}' |awk -F"ANN=" '{print $2}' | awk -F"|" '{print $2"\t"$3"\t"$11}' > snpEff2
paste -d "\t" snpEff1 snpEff2 > positive.snpEff
rm snpEff1 snpEff2

cat positive.snpEff|cut -f5|cut -d" " -f1|sort |uniq -c |sort -nr
