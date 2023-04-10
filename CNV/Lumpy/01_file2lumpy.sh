#! bin/bash
############################### lumpy ###############################

ls *markdup.bam|cut -d"." -f 1 | sort -u | while read id;
do
# 1.extract discordant paired-end alignments
samtools view -b -F 1294 \
${id}.sorted.addhead.markdup.bam \
> ${id}.discordants.unsorted.bam

# 2.extract split-reads alignments
samtools view -h $id.sorted.addhead.markdup.bam \
| /home/sll/miniconda3/bin/extractSplitReads_BwaMem -i stdin \
| samtools view -Sb - \
> ${id}.splitters.unsorted.bam

# 3.sort bams
samtools sort \
${id}.discordants.unsorted.bam \
${id}.discordants

samtools sort \
${id}.splitters.unsorted.bam \
${id}.splitters
done
