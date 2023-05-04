### 01_STAR-index.sh    STAR对参考基因组建索引
### 01_fastp.sh         fastp过滤
### 02_STAR_aln.sh      STAR比对，2-pass模式的比对（对于callsnp来说使用），保守方法
### 03_Add2markdup.sh   picard加头并排序，不过STAR的一个2-pass模式可以一步完成，我这个是保守方式
### 04_SplitNC2gvcf.sh  splicNC并进行变异鉴定
### 05_mergegvcf.sh     合并gvcf结果
### 06_genotype.sh      对gvcf进行基因分型
### 07_filter-selectvariant.sh 过滤并提取SNP
