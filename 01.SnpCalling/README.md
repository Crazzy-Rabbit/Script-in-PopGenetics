### GATK及ANGSD进行SNP calling
##### 01. read alignment, sort, and remove PCR duplication
```
bwa mem -t 4 -M -R '@RG\tID:$sample\tLB:$group\tPL:ILLUMINA\tSM:$sample' $reference.fa $fastq1 $fastq2 | samtools view -b -S -o $sample.bam
java -jar picard.jar SortSam I=$sample.bam O=$sample.sort.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT
java -jar picard.jar MarkDuplicates I=$sample.sort.bam O=$sample.dup.bam ASSUME_SORT_ORDER=coordinate METRICS_FILE=$sample.dup.txt VALIDATION_STRINGENCY=LENIENT

# bwa 中 -R 参数添加头文件信息， 若比对时未加这一参数则可用：
java -jar picard.jar AddOrReplaceReadGroups I=input.bam O=output.bam RGID=$sample RGLB=$sample RGPL=illumina RGPU=$samplePU RGSM=$sample
```
##### 02.variants calling using GATK4+
GATK4版本之后就不用对INDEL区域进行重比对了，方便
```
~/gatk-4.1.4.0/gatk HaplotypeCaller -R $reference.fa  -L $chr -ERC GVCF -I $bam -o $chr.gvcf.gz
~/gatk-4.1.4.0/gatk CombineGVCFs -R $reference.fa  --variant $chr.list -o $chr.gvcf.gz
~/gatk-4.1.4.0/gatk GenotypeGVCFs -R $reference.fa  --variant $chr.gvcf.gz --includeNonVariantSites -o $chr.vcf.gz

# -L 分染色体call，占用空间少, CombineGVCFs时指定$chr.list即可
# --includeNonVariantSite 保留非变异位点
```
##### 02.variants calling using GATK4+（hard filter）
SNP
```
~/gatk-4.1.4.0/gatk SelectVariants -R $reference.fa -V $Pop.vcf.gz -select-type SNP -o Pop.SNP.vcf.gz
~/gatk-4.1.4.0/gatk VariantFiltration -R $reference.fa -V Pop.SNP.vcf.gz  --filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0"  --filterName "my_snp_filter" -o Pop.HDflt.SNP.vcf.gz
```
INDEL
```
~/gatk-4.1.4.0/gatk SelectVariants -R $reference.fa -V $Pop.vcf.gz -selectType INDEL -o Pop.INDEL.vcf.gz
~/gatk-4.1.4.0/gatk VariantFiltration -R $reference.fa -V Pop.INDEL.vcf.gz --filterExpression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" --filterName "my_indel_filter" -o Pop.HDflt.INDEL.vcf.gz
```
merge and get PASS site
```
~/gatk-4.1.4.0/gatk MergeVcfs -I Pop.HDflt.SNP.vcf.gz -I Pop.HDflt.INDEL.vcf.gz -O Pop.HDflt.SNP.INDEL.genotype.vcf
~/gatk-4.1.4.0/gatk SelectVariants -R $reference.fa -V Pop.HDflt.SNP.INDEL.genotype.vcf -O Pop.HDflt.SNP.INDEL.genotype.pass.vcf -select "vc.isNotFiltered()"
```

##### 03.variants calling using ANGSD
```
angsd -bam $bam.list -only_proper_pairs 1 -uniqueOnly 1 -remove_bads 1 \
                     -minQ 20 -minMapQ 30 -C 50 -ref $reference.fa -r $chr \
                     -out $chr -doQsDist 1 -doDepth 1 -doCounts 1 -maxDepth $max

angsd -bam $bam.list -only_proper_pairs 1 -uniqueOnly 1 -skipTriallelic 1 -remove_bads 1 \
                     -minQ 20 -minMapQ 30 -C 50 -ref $reference.fa -r $chr -out $chr \
                     -doMaf 1 -doMajorMinor 1 -GL 1 -setMinDepth $mindepth -setMaxDepth $maxdepth \
                     -doCounts 1 -dosnpstat 1 -SNP_pval 1

# 第一步是call SNP，及计算多个参数
# 第二步是多个过滤参数，保证SNP的准确性
```
