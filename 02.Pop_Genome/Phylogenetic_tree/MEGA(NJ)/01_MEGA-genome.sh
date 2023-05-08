#转格式
plink --allow-extra-chr --chr-set 29 -vcf QC.ld.cattle_204_hebing_Chr1_29_genotype.nchr-geno005-maf003-502502.vcf \
                                     --make-bed --double-id \
                                     --out QC.ld.cattle_204_hebing_Chr1_29_genotype.nchr-geno005-maf003-502502
#计算genome
plink  --bfile QC.ld.cattle_204_hebing_Chr1_29_genotype.nchr-geno005-maf003-502502 --allow-extra-chr --chr-set 29  --genome
