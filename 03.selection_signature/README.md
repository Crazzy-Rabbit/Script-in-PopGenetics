一般而言，计算`Tajima's D`、`FST`、`pi`等我们都用`vcftools`，但由于这些方法基于频谱信息（frequency spectrum），因此会受到测序深度不均、数据缺失、`SNP calling`过程中`genotype`的不确定性等的影响(NGS数据的基本问题)

###### 注：目前用的所有的`SNP calling`的方式都是基于`genotype likelihood`(GL)的
```
depth 低于 20X 的数据，对genotype calling都会有些偏差，产生原因主要是genotype calling的方法
```
无论是什么情况，现有的这些软件都无法获得所有类型等位基因频率的`无偏估计`

##### 解决方法
first approach 
```
The first approach is based on obtaining a Maximum Likelihood (ML) estimate of the sample allele frequency spectrum.

基于最大似然法估计SFS，这种方法考虑了NGS数据的所有不确定性，并从估计的样本频谱中提供了中性测试统计数据的估计值
然而， 太慢了
```
secend approach
```
The second approach uses an empirical Bayes approach, that also uses an ML estimate of the site frequency spectrum
This estimate is used as a prior for calculating site specific posterior probabilities for the sample frequency spectrum. 

基于经验贝叶斯方法，对任何规模的基因组都可行
这种方式的偏差是最小的
```
# 计算选择信号的脚本
##### XP-EHH 中提供了计算win 和step的脚本，非常人性化
##### SweeD_CLR 中提共的脚本我们不用自己准备grid文件了
##### iHS 同样提供了计算win 和step的脚本
##### ln_πratio 提供了计算ln pi(a/b) 脚本
##### plot_Manhantan.R 绘制曼哈顿提，两种方式，CMplot和qqman，推荐CMplot
`CalZscorePvalue.py`进行Z检验并计算P值
```
python CalZscorePvalue.py --infile luxivsangus.xpehh --val-col normxpehh --outfile luxivsangus_xpehh_z-score.txt
```
