### Tajima's D
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
因此这里使用`ANGSD`软件直接从bam文件基于经验贝叶斯方法计算SFS，之后计算`Tajima's D`，得到的结果会更精确（我看一个文献是将`ANGSD`和`vcftools`的结果取了都有的位点作为`robust`）

##### 01_00.SFS(site frequency spectrum)likelihood estimated
```
./angsd -bam bam.filelist -doSaf 1 -anc chimpHg19.fa -GL 1 -P 24 -out out

-anc chimpHg19.fa   参考基因组fa文件
```
##### 01_01.0btain the maximum likelihood estimate of the SFS using the `realSFS` program
`unfolded spectrum` 祖先等位基因型已知
```
./misc/realSFS out.saf.idx -P 24 > out.sfs
```
`folded spectrum` 祖先等位基因型未知（一般用这个）
```
./misc/realSFS out.saf.idx -P 24 -fold 1 > out.sfs
```
To plot the SFS in R :
```
s<-scan('out.sfs')
s<-s[-c(1,length(s))]
s<-s/sum(s)
barplot(s,names=1:length(s),main='SFS')
```
###### 02.Calculate the thetas for each site
```
realSFS saf2theta out.saf.idx -sfs out.sfs -outname out
```
生成`out.thetas.gz` `out.thetas.idx`两个文件

##### 03_00.Estimate `Tajimas D` and other statistics
```
#calculate Tajimas D
./misc/thetaStat do_stat out.thetas.idx
```
```
./thetaStat print angsdput.thetas.idx

#Chromo Pos     Watterson       Pairwise        thetaSingleton  thetaH  thetaL
1       14000032        -9.457420       -10.372069      -8.319252       -13.025778      -10.997194
1       14000033        -9.463637       -10.379368      -8.324414       -13.035780      -11.004670
1       14000034        -9.463740       -10.379488      -8.324500       -13.035942      -11.004793
1       14000035        -9.463603       -10.379328      -8.324386       -13.035725      -11.004629
1       14000036        -9.323246       -10.218453      -8.204848       -12.826627      -10.840519


1. chromosome
2. position
3. ThetaWatterson
4. ThetaD (nucleotide diversity)
5. Theta? (singleton category)
6. ThetaH
7. ThetaL
```
生成`out.thetas.idx.pestPG`文件
```
cat out.thetas.idx.pestPG

## thetaStat VERSION: 0.01 build:(Jun 30 2014,12:06:12)
#(indexStart,indexStop)(firstPos_withData,lastPos_withData)(WinStart,WinStop)   Chr     WinCenter       tW      tP      tF      tH      tL      Tajima  fuf     fud     fayh    zeng    nSites
(0,98316)(14000032,14100082)(0,14100082)        1       7050041 51.002623       46.171402       64.683834       51.290955       48.731178       -0.392892       -0.647071       -0.595302       -0.099654       -0.048444       98316
(0,98474)(13999910,14100060)(0,14100060)        2       7050030 92.689100       88.806005       101.768262      122.422498      105.614255      -0.174701       -0.252477       -0.220588       -0.360944       0.152373        98474
(0,93269)(14000529,14100095)(0,14100095)        3       7050047 70.757874       76.248087       75.447438       68.354514       72.301301       0.322902        0.020330        -0.148419       0.110921        0.023794        93269
```
##### 03_01.Sliding Window example
```
thetaStat do_stat out.thetas.idx -win 50000 -step 10000  -outnames theta.thetasWindow.gz
```


