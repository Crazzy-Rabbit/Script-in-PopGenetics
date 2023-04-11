bfile="QC.common_89_cattle_851_ASIA-geno005-maf003"

## make germ
/home/software/gcta_1.92.3beta3/gcta64 --bfile $bfile \
                                       --make-grm --autosome-num 29 \
                                       --out $bfile.gcta
                                       
## PCA
/home/software/gcta_1.92.3beta3/gcta64 --grm $bfile.gcta \
                                       --pca 4 \
                                       --out $bfile.gcta.out
                                       
