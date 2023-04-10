#! bin/bash
############################### lumpy ###############################

sample=`ls *markdup.bam|cut -d"." -f 1 | sort -u`
for i in $sample;
do
# 1.extract discordant paired-end alignments
samtools view -b -F 1294 \
${sample}.sorted.addhead.markdup.bam \
> ${sample}.discordants.unsorted.bam

# 2.extract split-reads alignments
samtools view -h $sample \
| /home/sll/miniconda3/bin/extractSplitReads_BwaMem -i stdin \
| samtools view -Sb - \
> ${sample}.splitters.unsorted.bam

# 3.sort bams
samtools sort \
${sample}.discordants.unsorted.bam \
${sample}.discordants

samtools sort \
${sample}.splitters.unsorted.bam \
${sample}.splitters
done
