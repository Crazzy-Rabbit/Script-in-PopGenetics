### LUMPY的整合流程，比LUNPY步骤更加简洁，推荐，但是软件的准备非常麻烦，须有一定的linux基础
#### 1. `svtyper`软件版本应在0.7.0以上，低版本没有`--max_ci_dist`参数
#### 2. `bcftools`的版本不要太老，至少1.10以上（1.3绝壁报错），低版本的index没有`--thread`参数
#### 3. bam文件的`.bam.bai`索引文件需要提供，否则报错
```
samtools index input.bam
```
环境变量
```
将gsort mosdepth lumpy lumpy_filter svtyper svtools等软件放入环境变量

gsort mosdepth: export PATH=/home/sll/software:$PATH
lumpy lumpy_filter svtyper svtools:  export PATH=/home/sll/miniconda3/envs/python2.7/bin:$PATH

当然也可以改你的主目录下的.bash_profile文件, $HOME代表你的主目录路径，保存后另打开窗口生效
.bash_profile为隐藏文件
可用 ls -la 查看隐藏文件
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
