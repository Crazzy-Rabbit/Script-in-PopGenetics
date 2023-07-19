#!/bin/bash

fa="/home/sll/genome-sheep/Oar_rambouillet_v1.0-STAR/GCF_002742125.1_Oar_rambouillet_v1.0_genomic.fna"
gtf="/home/sll/genome-sheep/Oar_rambouillet_v1.0-STAR/GCF_002742125.1_Oar_rambouillet_v1.0_genomic.gtf"     
genomeDir="/home/sll/genome-sheep/Oar_rambouillet_v1.0-STAR"                                                    # STAR建好索引的基因组文件目录

mkdir -p starmap.bam/index
  # 1. 2 pass模式进行比对
ls *filter.fastq.gz | cut -d '_' -f 1 | sort -u | while read id;
do 
  STAR --twopassMode Basic \
       --runThreadN 10 --genomeDir $genomeDir \
       --readFilesCommand zcat \
       --alignSJstitchMismatchNmax 5 -1 5 5 \
       --sjdbOverhang 149 \
       --readFilesIn $id_1.filter.fastq.gz $id_2.filter.fastq.gz \
       --outSAMtype SAM \
       --outFileNamePrefix ./starmap.bam/$id_2pass
done
