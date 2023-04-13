# 3 merge samples
ls *gt.vcf > vcf.list

svtools vcfpaste -f  vcf.list  > all.genotype.vcf
