
# download file 
# wget -c -t 0 -O SRR13107018.sra https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR13107018/SRR13107018
#绵羊参考基因组
# /home/sll/genome-sheep/Oar_rambouillet_v1.0-ncbi/GCF_002742125.1_Oar_rambouillet_v1.0_genomic
#牛参考基因组
# /home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic
#绵羊gtf文件
# /home/sll/genome-sheep/Oar_rambouillet_v1.0-ncbi/GCF_002742125.1_Oar_rambouillet_v1.0_genomic.gtf
#牛gtf文件
# /home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.gtf
fastq-dump="/home/software/sratoolkit.2.9.6-1-centos_linux64/bin/fastq-dump"
fastp="/home/sll/miniconda3/bin/fastp"
hisat2="/home/sll/miniconda3/bin/hisat2"
samtools="/home/sll/miniconda3/bin/samtools"
featureCounts="/home/sll/miniconda3/bin/featureCounts"
multiqc="/home/sll/miniconda3/bin/multiqc"

genomefa="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic"                   # change as you want
genomegtf="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.gtf"              # change as you want 

mkdir hismap.sam
# ensure your sra file was xxx.sra format
ls *sra | while read id;
do echo $id
arr=($id)
sample=${arr[0]}

# 1 sra to fq_1 and fq_2
$fastq-dump --gzip --split-3 $sample
# 2 QC use fastp
$fsatp -i ${sample}_1.fastq.gz -I ${sample}_2.fastq.gz -g -q 15 -n 5 -l 150 -u 50 -o ${sample}_1.filter.fastq.gz -O ${sample}_2.filter.fastq.gz -h ${sample}.fastp.html
# 3 reads mapping  ----hisat2
$hisat2 -p 8 -x $genomefa -1 ${sample}_1.filter.fastq.gz -2 ${sample}_2.filter.fastq.gz -S hismap.sam/${sample}.hismap.sam       
# 4 sam to bam and sorted and index for *sort.bam file
$samtools view -S ./hismap.sam/${sample}.hismap.sam -b | samtools sort -@ 8 -o ${sample}_sort.bam | samtools index - ./hismap.sam/${sample}_sort.bam.index
done

# 5 featurecount count the reads number
$featureCounts -p -t -g gene_id -M -T 8 -a $genomegt -o all.featurecounts.txt ./hismap.sam/*_sort.bam
cd ..
# 6 multiqc 
$multiqc all.featurecounts.txt.summary -o  all.counts.summary

# 7 get counts to R 
awk -F '\t' '{printf $1; for(i=6;i<=NF;i++) printf FS $i; printf "\n"}' OFS='\t' all.featurecounts.txt > all_fcount.matrix.txt
