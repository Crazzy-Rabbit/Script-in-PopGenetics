## 1参考基因组建索引
STAR --runThreadN 6 --runMode genomeGenerate \
                    --genomeDir /home/sll/genome-sheep/Oar_rambouillet_v1.0-STAR\   # 索引目录，提前建好
                    --genomeFastaFiles GCF_002742125.1_Oar_rambouillet_v1.0_genomic.fna 
                    --sjdbGTFfile GCF_002742125.1_Oar_rambouillet_v1.0_genomic.gtf 
                    --sjdbOverhang 149          # reads长度减1
## 2.1.常规比对
#（一次2个吧）
STAR --runThreadN 10 --genomeDir /home/sll/genome-sheep/Oar_rambouillet_v1.0-STAR \
                     --readFilesIn SRR17709920_1.filter.fastq.gz SRR17709920_2.filter.fastq.gz \
                     --readFilesCommand gunzip -c \
                     --outFileNamePrefix ./starmap.bam/SRR17709920

#--readFilesIn ：paired reads文件
#--outSAMtype ：表示输出默认排序的bam文件，类似于samtools sort（还有--outSAMtype BAM Unsorted和--outSAMtype BAM Unsorted SortedByCoordinate）
#--outFileNamePrefix ：输出文件路径及前缀


## 2.2 2-pass模式
# （GATK专用）
# 1.建立索引，--sjdbFileChrStartEnd参数将所有样品的SJ.out.tab文件作为输入的annotated junction进行第二次建index。
STAR --runThreadN 20 --runMode genomeGenerate \
                     --genomeDir ./index \
                     --genomeFastaFiles /home/sll/genome-sheep/Oar_rambouillet_v1.0-STAR/GCF_002742125.1_Oar_rambouillet_v1.0_genomic.fna \
                     --sjdbGTFfile /home/sll/genome-sheep/Oar_rambouillet_v1.0-STAR/GCF_002742125.1_Oar_rambouillet_v1.0_genomic.gtf \
                     --sjdbFileChrStartEnd *.out.tab \
                     --sjdbOverhang 149

rm *sam
2.第二次比对，用第二次建立的index再一次对每个样品进行STAR比对
STAR --runThreadN 10 --genomeDir ./starmap.bam/index \
                     --readFilesIn SRR17709911_1.filter.fastq.gz SRR17709911_2.filter.fastq.gz \
                     --readFilesCommand gunzip -c \
                     --outFileNamePrefix ./starmap.bam/2_pass/SRR17709911_2pass
