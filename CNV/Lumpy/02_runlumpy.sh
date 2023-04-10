# 1.run lumpy
lumpyexpress \
-B ReiD-18.sorted.addhead.markdup.bam,ReiD-19.sorted.addhead.markdup.bam\ #指定输入文件,可以多个样品(逗号隔开)
-S ReiD-18.splitters.bam,ReiD-19.splitters.bam \             #指定分裂比对的文件，可以多个样品
-D ReiD-18.discordants.bam,ReiD-18.discordants.bam \           #指定不正常比对文件，可以多个样品 
-o all.sv.lumpy.vcf


ls *.markdup.bam | cut -d '.' -f 1 | sort -u | while read id;
do 
# 2.提取样本
vcftools --vcf all.sv.lumpy.vcf \ #指定提取样品名称
--indv $id --recode --recode-INFO-all
--out $id  #输出文件前缀

# 2. genotype
svtyper \
-B ${id}.sorted.addhead.markdup.bam \
-S ${id}.splitters.bam \
-i ${id}.recode.vcf
> ${id}.gt.vcf
done

# 3 merge samples
ls *gt.vcf > vcf.list

svtools vcfpaste -f  vcf.list  > all.genotype.vcf
