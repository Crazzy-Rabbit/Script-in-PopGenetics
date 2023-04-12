# 1、计算等位基因频率
# 转换为tped格式，生成sample.tped和sample.tfam文件。
vcftools --vcf QC.sample-select-geno005-maf003.vcf --plink-tped --out sample

sample.tfam修改第一列数据为breed ID。

#提取文件sample.pop.cov，格式为：共三列，前两列与修改后的sample.tfam前两列一样，为群体ID和样本ID，第三列和第一列一致，tab分隔。
cat sample.tfam |awk '{print $1"\t"$2"\t"$1}' >sample.pop.cov

#计算等位基因组的频率，生成plink.frq.strat和plink.nosex文件
plink --threads 12 --tfile sample --freq --allow-extra-chr --chr-set 29 --within sample.pop.cov 

#压缩等位基因频率文件
gzip plink.frq.strat 

#转换格式【耗时小时计】
#用treemix自带脚本进行格式转换，notes：输入输出都为压缩文件，plink2treemix.py使用python2并需要绝对路径（否则报错）。
python2 /home/sll/miniconda3/bin/plink2treemix.py plink.frq.strat.gz sample.treemix.in.gz 
