### The tips of VCFTOOLS
实用的vcftools小技巧
##### 1.convert vcf to bcf
```
vcftools --vcf input_data.vcf --recode-bcf --recode-INFO-all --out converted_output
```
##### 2.compare twe files
比较两个vcf共享的位点、个体
```
vcftools --vcf input_data.vcf --diff other_data.vcf --out compare

后面的一个参数可指定 --diff, --gzdiff, or --diff-bcf
```
##### 3.计算`allele frequency`
获得vcf文件中每个`allele`的频率
```
vcftools --vcf input_data.vcf --freq --out output
```
##### 4.计算FST,pi
```
vcftools --vcf input_data.vcf --weir-fst-pop population_1.txt --weir-fst-pop population_2.txt --out pop1_vs_pop2
vcftools --vcf input_data.vcf   --keep group.txt  --window-pi 10000 --window-pi-step 5000 --out group

--fst-window-size 指定窗口大小
--fst-window-step 指定步长大小
```

##### 5.convert to PLINK
```
vcftools --vcf input_data.vcf --plink --chr 1 --out output_in_plink

--chr 指定染色体号，否则chr列为空，或提前将chr转为数字形式
```

##### 6.计算TS/TV
```
vcftools --vcf input_data.vcf --TsTv-summary 
```
##### 7.提取样本
```
vcftools --gzvcf $vcf --keep $sample --recode --recode-INFO-all --out $sample
```
