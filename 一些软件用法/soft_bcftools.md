1、对VCF文件进行统计，统计`INDEL`和`SNP`长度数量等
```
bcftools stats  QC.wagyu.indels_pass.recode_geno01_maf005.vcf
```
2、提取`vcf`文件中的样本
```
bcftools view -S id.txt 20211005_sheep_222_total.vcf.gz > tibetan_36.vcf 

### 其中 id.txt 为一列样本id
```
3、去除多等位基因及INDEL
```
bcftools view -m 2 -M 2 --type "snps"  test.vcf.gz -Ov -o test.record.snps.vcf.gz

## 注意一下：-O为输出文件的格式，其中z为压缩的vcf文件，v为正常的vcf文件
```
