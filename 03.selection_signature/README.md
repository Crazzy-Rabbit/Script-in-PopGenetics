## 关于outlier阈值的选择
```
一般而言，是选择前1%或5%的窗口作为受选择窗口，但是这种标准的准确性如何却不得而知，因此，可利用群体模拟软件，如ms、msms、discoal等进行中性进化条件下的序列模拟，比较模拟序列与观测值的差异
```
一般而言，计算`Tajima's D`、`FST`、`pi`等我们都用`vcftools`，但由于这些方法基于频谱信息（frequency spectrum），因此会受到测序深度不均、数据缺失、`SNP calling`过程中`genotype`的不确定性等的影响(NGS数据的基本问题)

因此，多了解了解多种方法，不要固步自封，多种方式结合才是王道
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
### 计算选择信号的脚本
##### XP-EHH 中提供了计算win 和step的脚本，非常人性化
##### SweeD_CLR 中提共的脚本我们不用自己准备grid文件了
##### iHS 同样提供了计算win 和step的脚本
##### ln_πratio 提供了计算ln pi(a/b) 脚本
##### plot_Manhantan.R 绘制曼哈顿提，两种方式，CMplot和qqman，推荐CMplot，下面那个python脚本怒推

1.`CalZscorePvalue.py`进行Z检验并计算P值
```
python CalZscorePvalue.py --infile luxivsangus.xpehh --val-col normxpehh --outfile luxivsangus_xpehh_z-score.txt
```
2.`plot_Manhattan.py`绘制曼哈顿图
```
python /home/sll/script/selection/plot_Manhattan.py --infile output_xpehh.txt --chr-col X0 --loc-col X1 --val-col X4 --outfile xpehh.png --xlabel Chrosome --ylabel XP-EHH --cutoff cutoff.txt --ticklabelsize 12 --axlabelsize 15 --ylim -5 5

# 可设参数
注：cutoff.txt为两列文件，chr 和 阈值， chr列将所有染色体列出，阈值列为相同值
    infile需要根据染色体及位置从小到大排序（1 2 ...），否则会乱，一般选择信号出来的文件都是这种顺序，也不用改，有的加个头文件
--chr-col 和 --val-col（位置）共同确定了x轴

'--infile',               help='tsv文件,  包含header'
'--chr-col',              help='染色体列名'
'--loc-col',              help='x轴值列名'
'--val-col',              help='y轴值列名'
'--log-trans',            default=False, help='对val列的值取以10为底的对数'
'--neg-logtrans',         default=False, help='对val列的值取以10为底的负对数(画p值)'
'--outfile',              help='输出文件,根据拓展名判断输出格式'
'--xlabel',               help='输入散点图x轴标签的名称'
'--ylabel',               help='输入散点图y轴标签的名称'
'--ylim',                 default=None, help='y轴的显示范围,如0 1, 默认不限定'
'--invert-yaxis',         default=False, help='flag, 翻转y轴, 默认不翻转'
'--top-xaxis',            default=False, help='flag, 把x轴置于顶部, 默认在底部'
'--cutoff',               default=None, help='两列，第一列染色体号，第二列对应的阈值'
'--highlight',            default=None, help='和infile相同格式的文件,在该文件中的点会在曼哈顿图中单独高亮出来'
'--ticklabelsize',        default=10, help='刻度文字大小'
'--figsize',              default=(15, 5), help='图像长宽, 默认15 5'
'--axlabelsize',          default=10, help='x轴y轴label文字大小'
'--markersize',           default=6, help='散点大小'
'--chroms',               default=None, help='只用这些染色体,e.g --chr 6 --chr X will only plot chr6 and chrX.', multiple=True
'--fill-regions',         default=None, help='fill between regions in this <bed file> (no header)'
'--windowsize',           default=None, help='draw mean value in a specific window size', type=int
```
![xpehh](https://github.com/Crazzy-Rabbit/Script-in-Bio/assets/111029483/003002ea-d0ba-46e2-a66a-f0177cc9eb03)
