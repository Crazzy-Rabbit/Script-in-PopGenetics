### LUMPY的整合流程，比LUNPY步骤更加简洁，推荐，但是软件的准备非常麻烦，须有一定的linux基础
#### 1. `svtyper`软件版本应在0.7.0以上，低版本没有`--max_ci_dist`参数
#### 2. `bcftools`的版本不要太老，至少1.10以上（1.3绝壁报错），低版本的index没有`--thread`参数
#### 3. bam文件的`.bam.bai`索引文件需要提供，否则报错
```
samtools index input.bam
```
##### `SVtools`的问题：有些python包需要old版本(python2.7),否则在`merge`时会出错
在安装`svtools`之前，先安装以下包的版本
```
pip install statsmodels==0.9.0
pip install cachetools==0.3.1

然后 pip install svtools
```
##### 环境变量

将`gsort` `mosdepth` `duphold` `lumpy` `lumpy_filter` `svtyper` `svtools`等软件放入环境变量
###### 方法1：
```
gsort mosdepth duphold:

export PATH=/home/sll/software:$PATH
```
```
lumpy lumpy_filter svtyper svtools:

export PATH=/home/sll/miniconda3/envs/python2.7/bin:$PATH
```
###### 方法2：
当然也可以改你的主目录下的`.bash_profile`文件（可以避免每次打开窗口都得配置环境变量）, `$HOME`代表你的主目录路径，保存后另打开窗口生效
```
.bash_profile为隐藏文件
可用 ls -la 查看隐藏文件
```
##### 01.对每个个体进行call SV
```
/home/sll/software/smoove
smoove call --outdir results-smoove/ --name $sample --fasta $reference -p 1 --genotype /path/to/$sample.bam
```
###### 01_00.循环脚本
```
#! /bin/bash
## genotype for each sample
reference="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna"
smoove="/home/sll/software/smoove"

ls *markdup.bam|cut -d"." -f 1 | sort -u | while read sample;
do
$smoove call --outdir results-smoove/ --name $sample --fasta $reference -p 1 --genotype $sample.sorted.addhead.markdup.bam
done
```
##### 02.合并所有个体的联合位点
```
smoove merge --name merged -f $reference --outdir ./ results-smoove/*.genotyped.vcf.gz
```
##### 03.对这些为位点的每个个体call genetype
```
smoove genotype -d -x -p 1 --name $sample-joint --outdir results-genotped/ --fasta $reference --vcf merged.sites.vcf.gz /path/to/$sample.bam
```

###### 03_00.循环脚本
```
#! /bin/bash
## genotype for each sample
reference="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna"
smoove="/home/sll/software/smoove"

ls *markdup.bam|cut -d"." -f 1 | sort -u | while read sample;
do
$smoove genotype -d -x -p 1 --name $sample-joint --outdir results-genotped/ --fasta $reference --vcf merged.sites.vcf.gz $sample.sorted.addhead.markdup.bam
done
```
##### 04.合并所有个体VCF
```
smoove paste --name $cohort results-genotyped/*.vcf.gz
```
