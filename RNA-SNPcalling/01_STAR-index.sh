## 参考基因组建索引
STAR --runThreadN 6 --runMode genomeGenerate \
                    --genomeDir /home/sll/genome-sheep/Oar_rambouillet_v1.0-STAR \ # 索引目录。（需提前建好）,最后将fa 和gtf文件也放进去
                    --genomeFastaFiles GCF_002742125.1_Oar_rambouillet_v1.0_genomic.fna \
                    --sjdbGTFfile GCF_002742125.1_Oar_rambouillet_v1.0_genomic.gtf \
                    --sjdbOverhang 149
