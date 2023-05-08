# ANNOVAR变异注释
/home/sll/software/annovar

# 1、下载地址：
# http://www.openbioinformatics.org/annovar/download/0wgxR2rIVP/annovar.latest.tar.gz
# 2、解压：
# tar -zxvf annovar.latest.tar.gz
# 3、构建注释数据库：
# 下载注释gtf和fa文件:
# 4、下载安装gtfToGenePred工具
# wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64.v369/gtfToGenePred

# chmod +x gtfToGenePred

# 5 用 gtfToGenePred 工具将 GTF file 转换 GenePred file
/home/sll/software/gtfToGenePred -genePredExt bosTau9.refGene.gtf  bos1.2_refGene.txt

NCBI下载的第一次可能会能报错：使用下面脚本解决
位置：/home/sll/software/annovar/cattle
replacegtf.py （记得改内容，打开就会改）

/home/sll/software/gtfToGenePred -genePredExt GCF_002263795.1_ARS-UCD1.2_genomic_replace.gtf ARS-UCD1.2_refGene.txt

# 6 生成转录组信息文件


perl /home/sll/software/annovar/retrieve_seq_from_fasta.pl --format refGene \
                                                           --seqfile Bos_taurus.ARS-UCD1.2.dna.toplevel.fa Bos1.2_refGene.txt \
                                                           -outfile Bos1.2_refGeneMrna.fa


# -format指定gene definition file格式
# -seqfile 指定基因组序列文件名称
# -outfile 指定输出mRNA序列文件的名称
################################建库完成#######################################

注释示例：除了人之外的其他物种的自建库只能用annotate_variation.pl，也就是第一种注释

1、vcf转为适宜的格式
perl /home/sll/software/annovar/convert2annovar.pl -format vcf4old QC.JPBC-geno005-maf003.bed.vcf -outfile QC.JPBC-geno005-maf003.avinput 

#关于-format vcf4,并没有保留全部位点：
#WARNING to old ANNOVAR users: this program no longer does line-to-line conversion for multi-sample VCF files. If you want to include all variants in output, use '-format vcf4old' or use '-format vcf4 -allsample -withfreq' instead.

2、annotate_variation注释

NC染色体
第一种，使用annotate_variation.pl ，三种类型分开：
perl /home/sll/software/annovar/annotate_variation.pl -out jpbc.anno \
                                                      -dbtype refGene \
                                                      -buildver Bos1.2 QC.JPBC-geno005-maf003.avinput /home/sll/software/annovar/cattle/ \
                                                      -csvout

# -geneanno  表示使用基于基因的注释 一般是默认的
# -dbtype refGene  表示使用"refGene"类型的数据库
# -out jpbc.anno  表示输出以jpbc.anno为前缀的结果文件

# 基于基因 （一般是这个）
annotate_variation.pl -geneanno -dbtype refGene -buildver hg19 example/ex1.avinput humandb/
#基于区域
annotate_variation.pl -regionanno -dbtype cytoBand -buildver hg19 example/ex1.avinput humandb/ 
#基于筛选
annotate_variation.pl -filter -dbtype exac03 -buildver hg19 example/ex1.avinput humandb/


第二种，方便一点，基于table_annovar.pl，直接注释三种类型：
table_annovar.pl是ANNOVAR多个脚本的封装，可以一次性完成三种类型的注释

perl /home/sll/software/annovar/table_annovar.pl QC.JPBC-geno005-maf003.avinput /home/sll/software/annovar/cattle/ -buildver Bos1.2 -out jpbc.anno -remove -operation g -protocol refGene -nastring NA -csvout

# -buildver Bos1.2 表示使用的参考基因组版本为Bos1.2
# -out jpbc.anno 指定输出文件前缀为jpbc.anno
# -remove 表示删除中间文件
# -protocol 后跟注释来源数据库名称，每个protocal名称或注释类型之间只有一个逗号，并且没有空白
# -operation 后跟指定的注释类型，和protocol指定的数据库顺序是一致的，g代表gene-based、r代表region-based、f代表filter-based
# -nastring NA 表示用NA替代缺省值
# -csvout 表示最后输出.csv文件
