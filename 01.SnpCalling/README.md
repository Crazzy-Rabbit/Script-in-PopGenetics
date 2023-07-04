## 二代测序 reads 的比对
二代测序 reads 的比对分两步：
```
用 bwa 将 reads 比对到参考基因组
用 picard 去除 PCR 造成的重复 reads
最终得到比对后的 CRAM 文件，这是一种BAM的压缩格式，在 samtools 给的基准测试中，CRAM 大小约为 BAM 的一半。
```
`bwa` 软件实现了三种比对算法 `BWA-backtrack`, `BWA-SW` 和 `BWA-MEM`。第一种算法适用于长度在 100bp 以下的 reads，后两种算法适用于70bp至数M的长 reads。BWA-MEM 是最新的算法，70bp以上的 reads 用 BWA-MEM 就好，70b p以下的用 BWA-backtrack。
#### 01. read alignment, sort, and remove PCR duplication
```
bwa mem -t 4 -M -R '@RG\tID:$sample\tLB:$group\tPL:ILLUMINA\tSM:$sample' $reference.fa $fastq1 $fastq2 | samtools view -b -S -o $sample.bam
java -jar picard.jar SortSam I=$sample.bam O=$sample.sort.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT
java -jar picard.jar MarkDuplicates I=$sample.sort.bam O=$sample.dup.bam ASSUME_SORT_ORDER=coordinate METRICS_FILE=$sample.dup.txt VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=true
java -jar picard.jar SetNmMdAndUqTags I=$sample.dup.bam O=$sample.dup.sort.fix.bam CREATE_INDEX=true R=$reference.fa VALIDATION_STRINGENCY=LENIENT

# REMOVE_DUPLICATES=true 去除PCR重复
# SetNmMdAndUqTags 设置SAM/BAM文件中的 NM(比对质量)、MD(碱基差异)和 UQ(唯一比对性) 标签,后续过滤可能用得上
# NM(比对质量) > 20 的用于后续 SNP calling
# bwa 中 -R 参数添加头文件信息，
若比对时未加这一参数则可用：
java -jar picard.jar AddOrReplaceReadGroups I=input.bam O=output.bam RGID=$sample RGLB=$sample RGPL=illumina RGPU=$samplePU RGSM=$sample
```
## GATK及ANGSD进行SNP calling
#### 02.variants calling using GATK4+
GATK4版本之后就不用对INDEL区域进行重比对了，方便
```
~/gatk-4.1.4.0/gatk HaplotypeCaller -R $reference.fa  -L $chr -ERC GVCF -I $bam -o $chr.gvcf.gz
~/gatk-4.1.4.0/gatk CombineGVCFs -R $reference.fa  --variant $chr.list -o $chr.gvcf.gz
~/gatk-4.1.4.0/gatk GenotypeGVCFs -R $reference.fa  --variant $chr.gvcf.gz --includeNonVariantSites -o $chr.vcf.gz

# -L 分染色体call，占用空间少, CombineGVCFs时指定$chr.list即可
# --includeNonVariantSite 保留非变异位点
```
#### 02.variants calling using GATK4+（hard filter）
SNP
```
~/gatk-4.1.4.0/gatk SelectVariants -R $reference.fa -V $Pop.vcf.gz --select-type SNP -o Pop.SNP.vcf.gz
~/gatk-4.1.4.0/gatk VariantFiltration -R $reference.fa -V Pop.SNP.vcf.gz  --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0"  --filter-name "my_snp_filter" -o Pop.HDflt.SNP.vcf.gz
```
INDEL
```
~/gatk-4.1.4.0/gatk SelectVariants -R $reference.fa -V $Pop.vcf.gz --select-type INDEL -o Pop.INDEL.vcf.gz
~/gatk-4.1.4.0/gatk VariantFiltration -R $reference.fa -V Pop.INDEL.vcf.gz --filter-expression "QD < 2.0 || FS > 200.0 || SOR > 10.0 || MQRankSum < -12.5 || ReadPosRankSum < -20" --filter-name "my_indel_filter" -o Pop.HDflt.INDEL.vcf.gz
```
merge and get PASS site
```
~/gatk-4.1.4.0/gatk MergeVcfs -I Pop.HDflt.SNP.vcf.gz -I Pop.HDflt.INDEL.vcf.gz -O Pop.HDflt.SNP.INDEL.genotype.vcf
~/gatk-4.1.4.0/gatk SelectVariants -R $reference.fa -V Pop.HDflt.SNP.INDEL.genotype.vcf -O Pop.HDflt.SNP.INDEL.genotype.pass.vcf -select "vc.isNotFiltered()"
```
`call`完之后可根据质量值`QUAL >= 30`去除低质量位点
```
vcftools --gzvcf $vcf --minQ 30 --min-alleles 2 --max-alleles 2 --max-missing 0.9 --non-ref-ac 2 --remove-indels --recode --recode-INFO-all --out $filter

--minQ 30 保留QUAL >= 30
--min-alleles 2 保留双等位基因
--max-alleles 2 保留双等位基因
--non-ref-ac 2  保留非参考等位基因多余2个个体的位点
--remove-indels 去除INDEL
--remove-snps   去除SNP
--max-missing 0.9 缺失率 < 10% 的位点留下
```
整个硬过滤及质量控制流程`HardFilterSnpIndel.sh`

`GATK`最常用的是硬过滤，因为简单直接，但还有机器学习的方法`VQSR`那个更加适用于自己的数据
#### 03.variants calling using ANGSD
个人感觉还是`GATK`为主，这个就用来 call 出 SNP 之后与`GATK`结果取交集，让`SNP calling`结果更准确
```
angsd -bam $bam.list -only_proper_pairs 1 -uniqueOnly 1 -remove_bads 1 \
                     -minQ 20 -minMapQ 30 -C 50 -ref $reference.fa -r $chr \
                     -out $chr -doQsDist 1 -doDepth 1 -doCounts 1 -maxDepth $max

angsd -bam $bam.list -only_proper_pairs 1 -uniqueOnly 1 -skipTriallelic 1 -remove_bads 1 \
                     -minQ 20 -minMapQ 30 -C 50 -ref $reference.fa -r $chr -out $chr \
                     -doMaf 1 -doMajorMinor 1 -GL 1 -setMinDepth $mindepth -setMaxDepth $maxdepth \
                     -doCounts 1 -dosnpstat 1 -SNP_pval 1

# 第一步是call SNP，及计算多个参数
# 第二步是多个过滤参数及估计genotype likelihood（GL），保证SNP的准确性
# -SNP_pval 1     SNP的p_value，可用于过滤
# -doMajorMinor 1 最终文件无 ref alt 而是 major minor 形式
# -doMaf 1        1: Frequency (fixed major and minor)
# -GL 1           1: SAMtools
                  2: GATK
                  3: SOAPsnp
                  4: SYK
# -doGeno         进行genotype calling，
                  1：print out major minor
                  2: print the called genotype as -1,0,1,2 (count of minor)
                  4: print the called genotype as AA, AC, AG, ...
                  8: print all 3 posts (major,major),(major,minor),(minor,minor)
```
