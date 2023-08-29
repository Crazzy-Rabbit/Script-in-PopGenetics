#! /bin/bash
######### software dir #############
plink2treemixIN="/home/sll/script/treemix/plink2treemixIN.py"
######### args number  #############
if [[$# ne 3]]; then
    echo "err need args!"
    echo "input file is bed format prefix"
    echo "Usage: bash $0 <sample_list> <bed> <outprefix>"
    exit 1
fi




python $plink2treemixIN --sample 157_cattle_snp_geno01_maf005-ld502502_nchr.order.txt --bed /home/sll/20230818-sll-vcf/structure/NJtree/159_cattle_snp_geno01_maf005 --output tree
