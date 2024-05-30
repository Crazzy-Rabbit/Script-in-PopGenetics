### 几种识别SV以及CNV的软件
#### 一、CNV的识别
#### 个人推荐使用`CNVcaller`，是专门为动植物开发的群体水平识别`CNV`的软件（我的毕业论文的做法）

基于RD算法对于长度较短的DEL或DUP时表现出较低的效率，而`CNVcaller`对`DUP`的灵敏度和准确性都是最佳的

二代数据中LUMPY在调用不同大小的 DEL 方面表现出良好的表现，因此可用LUMPY来对DEL类型进行矫正，DUP类型以降低假阳性为主

这篇文章：https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1720-5
        
        
#### 更建议使用`SMOOVE`来`call SV`然后使用`svtools`注释`cnvnator`得到的相应的拷贝数
```
方案1： 推荐之后使用bedtools进行交集的获取（-f参数设置重叠比例），以CNVcaller为主，LUMPY结果用于矫正
方案2： 使用LUMPY获得CNV边界，再使用CNVnator进行CN的注释，这个流程也挺好
```
`lumpy`推荐用它的整合流程`Smoove`，挺简洁的
```
CNV的过滤一般利用其CN频率及CNVR的长度进行过滤
缺失型： 0.05<del<0.95且dup<=0.01 且 lenth <= 50000
重复型： 0.05<dup<0.95且del<=0.01 且lenth <= 500000
Both型： 0.05<dup<0.95 且 0.05<del<0.95 且 lenth <= 50000
```
#### 二、SV的识别
```
Delly、LUMPY、Manta、GenomeSTRiP，但还有其他软件如Sniffles（三代专用）等（过时了）

## 现在是泛基因组识别SV的时代

Sniffles对DEL类型的检测更为精确，因此对CNV的检测也可用此软件进行矫正DEL类型（PS：若条件允许，上三代测序）
```
`Manta`可一次性call全部个体SV
```
~/manta-1.6.0/bin/configManta.py --bam $name1.bam --bam $name2.bam --bam $name3.bam ... --referenceFasta $reference --runDir Manta_dir
```
对于二代数据，由于读长限制，其SV鉴定结果只保留`DEL`和`DUP`，因为其他的极不可信
```
过滤一般推荐根据第6列的QUAL进行过滤即可
LUMPY过滤第6列的QUAL为0的结果
其他软件过滤掉标记为IMPRECISE和LowQual的结果
```
###### 这里多软件鉴定结果就可以用`SUIVIVOR`进行合并了，当然也可以使用`svimmer`以及`Jasmine`来合并，后者估计效果比较好
`Jasmine`可以通过断裂位点合并SV，而SURVIVOR不行
```
svimmer --threads 10 all.vcf.list NC. NC. NC. NC. <......> # 染色体名称
```
进行`SV`鉴定最好是能有三代的数据，二代三代一起搞才有搞头，相互矫正那种

且三代SV的检测最好加上基于 Assembly 的方法，如`Assemblytics`软件

可惜条件有限，不能深入探索，啊啊啊，shit，好烦~！！！！
