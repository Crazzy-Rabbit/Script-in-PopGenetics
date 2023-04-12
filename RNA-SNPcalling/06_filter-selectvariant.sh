# filter
/home/software/gatk-4.1.4.0/gatk VariantFiltration -R /home/sheep-reference/GCF_002742125.1_Oar_rambouillet_v1.0_genomic.fna \
                                                   -V combined.genotype.vcf \
                                                   -O combined.genotype.filter.vcf \
                                                   --window 35 --cluster 3 \
                                                   --filter-name one --filter-expression "FS>30.0" \
                                                   --filter-name two --filter-expression "QD<2.0"
                                                   
 # selsction variant                                                  
/home/software/gatk-4.1.4.0/gatk SelectVariants --exclude-filtered \
                                                -R /home/sheep-reference/GCF_002742125.1_Oar_rambouillet_v1.0_genomic.fna \
                                                -V combined.genotype.filter.vcf \
                                                -O combined.genotype.filter.retain.vcf                                                                                                   
