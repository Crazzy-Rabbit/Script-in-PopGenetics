#### snpEff建库
###### 1、配置自己的基因组和注释文件
```
以驯鹿（red deer）参考基因组为例：打开snpEFF文件夹下的snpEff.contig，在Third party databases下面增加新的物种信息

#-------------------------------------------------------------------------------
# Third party databases    （原来的）
#-------------------------------------------------------------------------------
#RedDeer genome, version RedDeerv1.1 （新加的）
RedDeerv1.1.genome : RedDeer   （新加的）

# Databases for human GRCh38 (hg38)    （原来的）
```
##### 2、建库
```
# 在SnpEff目录下，data/RedDeerv1.1, data/genomes
mkdir RedDeerv1.1 

# 将 gtf 文件放入RedDeerv1.1目录下，并改名为 genes.gtf
# 将基因组序列文件（.fasta）放入 genomes 目录下，并改名为RedDeerv1.1.fa
# 在 snpEff 目录下，执行命令
/home/sll/miniconda3/bin/java -jar /home/sll/software/snpEff/snpEff.jar build -gtf22 \
                                                    -v RedDeerv1.1 \
                                                    -noCheckCds \
                                                    -noCheckProtein &

系统的java报错，用自己的
# -noCheckCds 不检查CDS区
# -noCheckProtein 不检查蛋白质
#如果不加上述两个参数，snpEff软件默认检查，则需要我们提供物种相应的CDS及蛋白质的fa文件
```

##### 注释示例
```
nohup java -Xmx4g -jar /home/sll/software/snpEff/snpEff.jar RedDeerv1.1 -i bed test-awk.bed   > test-awk.anno.bed &
```

##### 脚本`TratesnpEffOutfile.py`
用于对snpEff软件注释后的.anno.bed文件进行提取，提取后的每个变异占一行，方便查看对应的选择信号值与变异的关系，效果如下
```
# SnpEff version 5.0 (build 2020-08-09 21:23), by Pablo Cingolani
# Command line: SnpEff  sheepv1.0 -i bed all.chart.ihs.out.50k.windows.5%.sort.chr.bed 
# Chromo	Start	End	Name	Effect	Gene	BioType	Score
NC_040258.1	80900001	80950001	0.175676	Upstream:29974	Transcript:XM_015097123.2:protein_coding	Gene:FUT8:protein_coding
NC_040258.1	80900001	80950001	0.175676	Upstream:28742	Transcript:XM_012181844.3:protein_coding	Gene:FUT8:protein_coding
NC_040258.1	80900001	80950001	0.175676	Exon:1:12:RETAINED	Transcript:rna-XM_015097123.2	Gene:exon-XM_015097123.2-1:null
NC_040258.1	80900001	80950001	0.175676	Upstream:29974	Transcript:rna-XM_015097123.2	Gene:exon-XM_015097123.2-1:null
NC_040258.1	80900001	80950001	0.175676	Transcript:XM_012181844.3:protein_coding	Gene:FUT8:protein_coding
NC_040258.1	80900001	80950001	0.175676	Transcript:XM_015097123.2:protein_coding	Gene:FUT8:protein_coding
NC_040258.1	80900001	80950001	0.175676	Exon:1:12:RETAINED	Transcript:rna-XM_012181844.3	Gene:exon-XM_012181844.3-1:null
NC_040258.1	80900001	80950001	0.175676	Upstream:28742	Transcript:rna-XM_012181844.3	Gene:exon-XM_012181844.3-1:null
NC_040258.1	80900001	80950001	0.175676	Intergenic:LOC101111101-GENE_exon-XM_012181844.3-1
NC_040260.1	77300001	77350001	0.175676	Intergenic:GENE_exon-XM_015097839.2-1-LOC114116467
NC_040277.1	39800001	39850001	0.175772	Exon:5:6:RETAINED	Transcript:rna-XM_012106001.3	Gene:exon-XM_012106001.3-1:null
NC_040277.1	39800001	39850001	0.175772	Transcript:XM_004021795.4:protein_coding	Gene:GOLGA7:protein_coding
NC_040277.1	39800001	39850001	0.175772	Exon:6:8:RETAINED	Transcript:rna-XM_015104630.2	Gene:exon-XM_015104630.2-1:null
NC_040277.1	39800001	39850001	0.175772	Exon:3:8:RETAINED	Transcript:rna-XM_015104630.2	Gene:exon-XM_015104630.2-1:null
NC_040277.1	39800001	39850001	0.175772	Exon:6:6:RETAINED	Transcript:rna-XM_004021795.4	Gene:exon-XM_004021795.4-1:null
NC_040277.1	39800001	39850001	0.175772	Transcript:XM_015104630.2:protein_coding	Gene:GINS4:protein_coding
NC_040277.1	39800001	39850001	0.175772	Downstream:0	Transcript:rna-XM_015104630.2	Gene:exon-XM_015104630.2-1:null
NC_040277.1	39800001	39850001	0.175772	Exon:7:8:RETAINED	Transcript:rna-XM_015104630.2	Gene:exon-XM_015104630.2-1:null
NC_040277.1	39800001	39850001	0.175772	Upstream:27365	Transcript:rna-XM_015104630.2	Gene:exon-XM_015104630.2-1:null
NC_040277.1	39800001	39850001	0.175772	Downstream:0	Transcript:XM_015104630.2:protein_coding	Gene:GINS4:protein_coding
NC_040277.1	39800001	39850001	0.175772	Exon:2:8:RETAINED	Transcript:rna-XM_015104630.2	Gene:exon-XM_015104630.2-1:null
NC_040277.1	39800001	39850001	0.175772	Downstream:0	Transcript:rna-XM_012106001.3	Gene:exon-XM_012106001.3-1:null
NC_040277.1	39800001	39850001	0.175772	Transcript:XM_012106001.3:protein_coding	Gene:GOLGA7:protein_coding
```
