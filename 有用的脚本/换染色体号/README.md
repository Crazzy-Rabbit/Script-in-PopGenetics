`ReplaceChr.py`用法
```
python chr.py -i QC.JBC_EU.chr29.recode.vcf -c NC-chr1.txt -o 1.out.txt
```
NC-chr1.txt为两列的文件，NC和数字染色体，随意在那一列都可，自动识别vcf染色体号形式，若为NC则换位数字，若为数字则换位NC

`replace.chr.py`为`ReplaceChr.py`的优化版本，优化了执行速度和内存占用（借助AI之力）
###### 不仅会更改VCF中的，还同时改头文件中的contig后的号

