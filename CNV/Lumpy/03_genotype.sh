#!/bin/bash
# python 2.7的环境

ls *.markdup.bam | cut -d '.' -f 1 | sort -u | while read id;
do 
# 2.提取样本
vcftools --vcf all.sv.lumpy.vcf \ #lumpy的输出文件
         --indv $id --recode --recode-INFO-all \ 
         --out $id #输出文件前缀

# genotype
svtyper \
-B ${id}.sorted.addhead.markdup.bam \
-S ${id}.splitters.bam \
-i ${id}.recode.vcf \
> ${id}.gt.vcf
done
