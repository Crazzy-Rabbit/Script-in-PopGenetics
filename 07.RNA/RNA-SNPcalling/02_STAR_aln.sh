#!/bin/bash

fa="/home/sll/genome-sheep/Oar_rambouillet_v1.0-STAR/GCF_002742125.1_Oar_rambouillet_v1.0_genomic.fna"
gtf="/home/sll/genome-sheep/Oar_rambouillet_v1.0-STAR/GCF_002742125.1_Oar_rambouillet_v1.0_genomic.gtf"     
genomeDir="/home/sll/genome-sheep/Oar_rambouillet_v1.0-STAR"                                                    # STAR建好索引的基因组文件目录

mkdir -p starmap.bam/index
  # 1. 2 pass模式进行比对
ls *filter.fastq.gz | cut -d '_' -f 1 | sort -u | while read id;
do 
  STAR --runThreadN 10 --genomeDir $genomeDir \
                       --readFilesIn $id_1.filter.fastq.gz $id_2.filter.fastq.gz \
                       --readFilesCommand gunzip -c \
                       --outFileNamePrefix ./starmap.bam/$id
done


  STAR --runThreadN 20 --runMode genomeGenerate \
                       --genomeDir ./starmap.bam/index \
                       --genomeFastaFiles $fa \
                       --sjdbGTFfile $gtf \
                       --sjdbFileChrStartEnd ./starmap.bam/*.out.tab \
                       --sjdbOverhang 149


ls *filter.fastq.gz | cut -d '_' -f 1 | sort -u | while read id;
do
  STAR --runThreadN 10 --genomeDir ./starmap.bam/index \
                       --readFilesIn $id_1.filter.fastq.gz $id_2.filter.fastq.gz \
                       --readFilesCommand gunzip -c \
                       --outFileNamePrefix ./starmap.bam/2_pass/$id_2pass

done
