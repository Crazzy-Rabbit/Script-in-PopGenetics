#! /bin/bash
## 精准而优雅
#################### Hard filter for SNP ######################
# 如果想要位点多点，则最后--minQ可不设置
# vcftools --non-ref-ac 2  保留非参考等位基因多余2个个体的位点
# 看自己情况设还是不设
###############################################################
# Set up the file name, software
GATK="/home/software/gatk-4.1.4.0/gatk"                # change as you want
vcftools="/home/sll/miniconda3/bin/bcftools"           # change as you want
reference="/home/sll/genome"                           # reference genome fasta file

if [[ $# -ne 2 ]]; then 
    echo "Usage: bash $0  <vcf.gz file>  <outprefix>"
    echo "输出文件前缀推荐和输入文件一样吧"
    echo "对SNP和INDEL进行硬过滤及SNP去除多等位基因，输出过滤后的SNP及INDEL文件"
    exit 1
fi

vcf=$1
out=$2

## get SNP and INDEL
$GATK SelectVariants -R $reference --select-type  SNP  -V $vcf  -O ${out}.snps.vcf.gz
$GATK SelectVariants -R $reference --select-type  INDEL  -V $vcf  -O ${out}.indel.vcf.gz
## filter SNP and INDEL
$GATK VariantFiltration -R $reference -V ${out}.snps.vcf.gz --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "SNP_FILTER" -O ${out}.snps.HDflt.vcf.gz
$GATK VariantFiltration -R $reference -V ${out}.snps.vcf.gz --filter-expression "QD < 2.0 || FS > 200.0 || SOR > 10.0 || MQRankSum < -12.5 || ReadPosRankSum < -20" --filter-name "INDEL_FILTER" -O ${out}.indel.HDflt.vcf.gz
## get pass for SNP and INDEL
$GATK MergeVcfs -I ${out}.snps.HDflt.vcf.gz -I ${out}.indel.HDflt.vcf.gz -O ${out}.SNP.INDEL.HDflt.vcf.gz
$GATK SelectVariants -R $reference -V ${out}.SNP.INDEL.HDflt.vcf.gz -O ${out}.SNP.INDEL.HDflt.pass.vcf.gz -select "vc.isNotFiltered()"

## get SNP and indel
$vcftools --gzvcf ${out}.SNP.INDEL.HDflt.pass.vcf.gz --minQ 30 --min-alleles 2 --max-alleles 2 --remove-indels --recode --recode-INFO-all --out ${out}.SNP.HDflt.pass
$vcftools --gzvcf ${out}.SNP.INDEL.HDflt.pass.vcf.gz --minQ 30 --min-alleles 2 --max-alleles 2 --remove-snps --recode --recode-INFO-all --out ${out}.INDEL.HDflt.pass
