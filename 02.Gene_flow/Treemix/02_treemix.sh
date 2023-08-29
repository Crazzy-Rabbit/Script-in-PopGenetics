#! /bin/bash

plink2treemixIN="/home/sll/script/treemix/plink2treemixIN.py"


python $plink2treemixIN --sample 157_cattle_snp_geno01_maf005-ld502502_nchr.order.txt --bed /home/sll/20230818-sll-vcf/structure/NJtree/159_cattle_snp_geno01_maf005 --output tree
