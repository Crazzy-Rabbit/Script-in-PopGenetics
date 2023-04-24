#!/bin/bash

picard="/home/software/picard/build/libs/picard.jar"

ls *filter.fastq.gz | cut -d '_' -f 1 | sort -u | while read id;
do
  # 1. picard加头排序
  java -jar -Xmx15g $picard AddOrReplaceReadGroups \
                       I=${id}_2passAligned.out.sam \
                       O=./sample_RNA_SNP_calling/${id}_sort_added.bam \
                       SO=coordinate \
                       RGID=${id} RGLB=mRNA RGPL=illumina RGPU=NovaSeq6000 RGSM=${id} #按照自己测序的来
  # 2. 标记重复
  java -jar -Xmx15g $picard MarkDuplicates \
                       I=${id}_sort_added.bam \
                       O=${id}.sorted.addhead.markdup.bam \
                       M=${id}.sorted.addhead.markdup.metrics.txt \
                       CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT

done
