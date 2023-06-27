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
