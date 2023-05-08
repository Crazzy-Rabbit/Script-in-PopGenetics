# 制作一列的ID的每个群体txt文件
# (保证当前目录没有其他txt文件的情况下，运行以下脚本）
ls *.txt | cut -d '.' -f 1 | sort -u | while read id; 
do 
    PopLDdecay -InVCF QC.sample-select-out-geno005-maf003.vcf -OutStat ${id}_sample.stat -MaxDist 1000 -SubPop ${id}.txt;
done
