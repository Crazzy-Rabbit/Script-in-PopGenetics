# Script-in-Bio
一些基因组分析中用到的脚本

<a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FCrazzy-Rabbit%2FScript-in-Bio&count_bg=%2379C83D&title_bg=%23555555&icon=microgenetics.svg&icon_color=%23E7E7E7&title=%E8%AE%BF%E9%97%AE%E9%87%8F&edge_flat=false"/></a>

- [ ] pangenome --->  want to learn and do in the future
- [ ] 单细胞分析 --->  want to learn and do in the future
    - [X] 用的[Seurat4](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/%E5%8D%95%E7%BB%86%E8%83%9ERNA-Seq%E5%88%86%E6%9E%90)，从前期处理到UMAP降维的记录
- [ ] 孟德尔随机化 --->  want to learn and do in the future
    - [ ] 整合多组学--SMR分析，精确定位致病突变
- [ ] 算法 + 数据结构 --->  want to learn and do in the future
    - [x] Python 基础
    - [x] R绘图

- [X] 绘图等的脚本可以找另一个目录 [Rscript-to-anaylise-and-visualize](https://github.com/Crazzy-Rabbit/Rscript-to-anaylise-and-visualize)，无毒，放心食用
    - [X] 绘图学习网站，需要有点R语言基础了
        - [ ] https://r-charts.com/  推荐给R绘图网站，提供绘图脚本
        - [ ] https://r-graph-gallery.com/  再来一个，里面是一些绘图示例
        - [ ] https://z3tt.github.io/beyond-bar-and-box-plots/  箱线图、条形图及衍生，一些绘图示例
        - [ ] https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/  ggplot2绘图示例
        - [ ] https://rkabacoff.github.io/datavis/IntroGGPLOT.html 也是个可视化学习网站
    - [X] 在线画图网站，给数据就行的那种
        - [ ] https://hiplot.com.cn/login?redirect=%2Fcloud-tool%2Fdrawing-tool%2Flist   hiplot--基本上用的图他都有
        - [ ] http://www.biolantern.top/biolantern/index.php   同上喽
- 理论知识等，可以在[`Genome-analysis`](https://github.com/Crazzy-Rabbit/Genome-analysis)找到


### 目录
- [SNP-calling](https://github.com/Crazzy-Rabbit/Script-in-Bio/01.SnpCalling)
   - 包括BWA-GATK以及ANGSD
- [CNV](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/06.CNV)
常用的方法是基于测序深度RD的策略，但是测序深度低的话会影响
   - [CNVcaller](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/06.CNV/CNVcaller)基于RD
   - [CNVnator](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/06.CNV/CNVnator)
   - [LUMPY](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/06.CNV/Lumpy)他的分析过程有点繁琐
   - 这个[Smoove](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/06.CNV/Smoove)是对LUMPY的整合，操作简单
   - 当然像结构变异这种大片段变异，还是建议有三代数据，无论是由三代检测出SV，然后用二代进行重新召回，还是都用三代，结果都是比二代数据call要好的多的
    
- [群体遗传结构分析](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome)
   - [ADMIXTURE](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Admixture)
     - [不设定bootstrap](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Admixture/01_cal-Admixture.sh)
     - [bootstrap](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Admixture/admixture_bootstrap.sh)
     这个的用意是设定随机数种子，然后进行自举重复，让最后的结果更合理
     - [CV计算](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Admixture/cal_cv.sh)
     用于对自举重复的CV进行计算统计
     - [可视化](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Admixture/03_plot-Admixture.R)
     这个图我还是很满意的
   - [PCA](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/PCA)
  这里有两种进行PCA的软件，一直用的是GCTA
     - [GCTA](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/PCA/GCTA)
     - [smartPCA](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/PCA/smartPCA)这个软件需要自己给好几个文件，我写了个shell进行生成，肯定比完全按他的流程走方便的
   - [Tree](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Phylogenetic_tree)
  系统发育树的话我们一般用的就是ML或者是NJ了，NJ快，ML准确
     - [ML-RAxML](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Phylogenetic_tree/RAxML(ML))，他的运行时间是比IQ-TREE长的
     - [ML-IQTREE](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Phylogenetic_tree/iq-tree(ML))
     - 用PLINK计算的遗传距离，然后写了个Python脚本生成[NJ-MEGA](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Phylogenetic_tree/MEGA(NJ))的输入文件.meg，其实就是个遗传距离矩阵
     - [NJ-VCF2Dis](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Phylogenetic_tree/VCF2Dis(NJ))这个软件试过一次，运行时间也挺长的
- [选择信号分析](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature)
  - FST
  这个是没有方向性的，即分析结果看不出是哪个群体受的选择信号
      - [ANGSD](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/FST%20using%20ANGSD)
      - [VCFTOOLS](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/Fst)
  - [XP-EHH](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/XP-EHH)
  基于单倍型的方法，计算群体间选择信号，越高表示在A受选择，越低表示在B受选择，有方向
  - [XP-CLR](https://github.com/Crazzy-Rabbit/Script-in-Bio/blob/main/03.selection_signature/XP-CLR.sh)
  - [ln_πratio](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/ln_%CF%80ratio)
  pi的衍生方法
  - [CLR](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/SweeD_CLR)
  - [iHS](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/iHS)
  基于单倍型的方法，计算群体内选择信号
  - [曼哈顿图](https://github.com/Crazzy-Rabbit/Script-in-Bio/blob/main/03.selection_signature/plot_Manhantan.R)
- [变异注释](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/04.Annoation)
两种，从建库开始详细记录，看个人喜好
  - [ANNOVAR](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/04.Annoation/Annovar)
  - [snpEff](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/04.Annoation/snpEff)
  - bedtools软件也是可以的哦，有需要自己学
- [遗传多样性](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/05.Genome_Diversity)
  - [HO-HE](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/05.Genome_Diversity/HO_HE)
  - [LD](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/05.Genome_Diversity/LD)只记录了LDdeacy，至于LDblock，一般是在GWAS的时候确定有连锁关系的位点
  - [近交系数](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/05.Genome_Diversity/%E8%BF%91%E4%BA%A4%E7%B3%BB%E6%95%B0)
  PLINK的het， GCTA的grm，以及基于ROH计算的

- [基因流](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Gene_flow)，这个就是纯属个人兴趣了，里面的脚本仅用于测试，不过有问题还是可以联系探讨的（包括群体历史等）
- [RNA](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/07.RNA)分析的话，好久之前学的了，先记上
  - 用hisat2 featurecount deseq2进行的[差异表达分析](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/07.RNA/RNA-DEG)
  - 利用STAR及GATK进行[转录组SNP的calling](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/07.RNA/RNA-SNPcalling)
  - rMAT的[可变剪切分析](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/07.RNA/RNA-AS)，这个也是粗略的学了一下，毕竟用不上，纯属个人兴趣

- 至于[GWAS]，等以后用的再学一下吧
 
- 基因组圈图[Circos](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/circos%E7%BB%98%E5%88%B6%E5%9F%BA%E5%9B%A0%E7%BB%84%E5%9C%88%E5%9B%BE)
  - 可用于绘制变异在染色体上的分布，挺好用的，就是安装有点费劲，需要的依赖包过多
  - `https://circos.ca/documentation/images/small/`，这个是他的官网，里面有各种图及其绘图配置文件示例
### 看都看完了，顺手点个赞呗！！！
  
     
