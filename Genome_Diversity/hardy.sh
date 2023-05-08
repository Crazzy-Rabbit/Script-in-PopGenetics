for i in Angus Holstein Simmental Shorthorn Charolais Hanwoo JPBC Mishima-Ushi Kazakh Mongolian Yanbian Wenling Brahman;
do plink --allow-extra-chr --chr-set 29 \
                      --bfile /home/sll/2022-DNA-cattle-graduate/20221026_wenzhang/vcf/QC.sample126.chart.filter-geno005-maf003 \
                      --keep /home/sll/2022-DNA-cattle-graduate/20221026_wenzhang/genomic-diversity/ROH/breed/${i}.txt \
                      --hardy \
                      --out ${i};
done
