#### LUMPY的整合流程，比LUNPY步骤更加简洁，推荐，但是软件的准备非常麻烦，须有一定的linux基础
#### svtyper软件版本应在0.7.0以上，否则会报错没有这个参数--max_ci_dist
#### bcftools的版本不要太老，至少1.10以上
```
使用前将gsort mosdepth lumpy lumpy_filter svtyper svtools等软件放入环境变量
gsort mosdepth 可用export PATH=/home/sll/software:$PATH
lumpy lumpy_filter svtyper svtools 可用 export PATH=/home/sll/miniconda3/envs/python2.7/bin:$PATH
```
##### 01.对每个个体进行call SV
```
/home/sll/software/smoove
smoove call --outdir results-smoove/ --name $sample --fasta $reference_fasta -p 1 --genotype /path/to/$sample.bam
```

##### 02.合并所有个体的联合位点
```
smoove merge --name merged -f $reference --outdir ./ results-smoove/*.genotyped.vcf.gz
```
##### 03.对这些为位点的每个个体call genetype
```
smoove genotype -d -x -p 1 --name $sample-joint --outdir results-genotped/ --fasta $reference --vcf merged.sites.vcf.gz /path/to/$sample.bam
```
##### 04.合并所有个体VCF
```
smoove paste --name $cohort results-genotyped/*.vcf.gz
```
