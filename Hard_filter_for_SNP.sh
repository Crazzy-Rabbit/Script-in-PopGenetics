#! /bin/bash
#################### Hard filter for SNP ######################

# Set up the file name, software
Vcf="20230218-deer-54-chr_1"                           #change as you want
GATK="/home/software/gatk-4.1.4.0"                     #change as you want

## get SNP
${GATK}/gatk  SelectVariants  --select-type  SNP  \
                              -V ${Vcf}.vcf.gz  \
                              -O ${Vcf}.snps.vcf.gz

## filter SNP
${GATK}/gatk VariantFiltration -V ${Vcf}.snps.vcf.gz \
                                --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" \
                                --filter-name "SNP_FILTER" \
                                -O ${Vcf}.snps.filter.vcf.gz

# index
bcftools index -t ${Vcf}.snps.filter.vcf.gz

## get pass 
${GATK}/gatk  SelectVariants -V ${Vcf}.snps.filter.vcf.gz \
                             -O ${Vcf}.snps.filter.pass.vcf.gz \
                             -select "vc.isNotFiltered()"

# delect muitl allells
bcftools view -m 2 -M 2 \
              --type "snps"  ${Vcf}.snps.filter.pass.vcf.gz \
              -Ov -o ${Vcf}.snps.filter.pass.2allell.vcf
