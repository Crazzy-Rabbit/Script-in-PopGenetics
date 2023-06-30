#### Delly2 call SV
Delly软件也是根据多种检测策略检测SV的软件， 这个软件过程和LUMPY（smoove）好像
##### 1.对每个个体Call sv
```
delly call -g $reference  -o $name.bcf $name.bam
```
##### 2.合并所有个体SV
```
delly merge -o all.sites.bcf $name1.bcf $name2.bcf $name3.bcf ...
```
##### 3.对所有的位点每个个体call genotype
```
delly call -g $reference -v all.sites.bcf -o $name1.geno.bcf $name1.bam
```
##### 4.合并多个体genotype 后的bcf
```
bcftools merge -m id -O b -o merge.final.bcf $name1.geno.bcf $name2.geno.bcf $name3.geno.bcf ...
```
##### 5.将bcf转为vcf格式
```
bcftools view $name1.bcf > $name1.vcf
```
