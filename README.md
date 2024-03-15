# Script-in-Bio
一些基因组分析中用到的脚本

<a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FCrazzy-Rabbit%2FScript-in-Bio&count_bg=%2379C83D&title_bg=%23555555&icon=microgenetics.svg&icon_color=%23E7E7E7&title=%E8%AE%BF%E9%97%AE%E9%87%8F&edge_flat=false"/></a>

### 别偷偷看啊喂，顺手点个赞
- [ ] pangenome --->  want to learn and do in the future
- [ ] 单细胞分析 --->  want to learn and do in the future
- [ ] 孟德尔随机化 --->  want to learn and do in the future
    - [ ] 整合多组学--SMR分析，精确定位致病突变
- [ ] 算法 + 数据结构 --->  want to learn and do in the future
    - [x] Python 基础
    - [x] R绘图

- 绘图等的脚本可以找另一个目录 `Rscript-to-anaylise-and-visualize`
- 理论知识等，可以在`Genome-analysis`找到

### 目录
- [SNP-calling](https://github.com/Crazzy-Rabbit/Script-in-Bio/01.SnpCalling)
   - 包括BWA-GATK以及ANGSD
- [群体遗传结构分析](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome)
   - [ADMIXTURE](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Admixture)
     - [不设定bootstrap](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Admixture/01_cal-Admixture.sh)
     - [bootstrap](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Admixture/admixture_bootstrap.sh)
     这个的用意是设定随机数种子，然后进行自举重复，让最后的结果更合理
     - 用于对自举重复的CV进行计算统计[CV计算](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Admixture/cal_cv.sh)
     - 这个图我还是很满意的[可视化](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Admixture/03_plot-Admixture.R)
   - [PCA](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/PCA)
     - [GCTA](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/PCA/GCTA)
     - [smartPCA](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/PCA/smartPCA)
   - [Tree](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Phylogenetic_tree)
     - [ML-RAxML](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Phylogenetic_tree/RAxML(ML))
     - [ML-IQTREE](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Phylogenetic_tree/iq-tree(ML))
     - [NJ-MEGA](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Phylogenetic_tree/MEGA(NJ))
     - [NJ-VCF2Dis](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/02.Pop_Genome/Phylogenetic_tree/VCF2Dis(NJ))
- [选择信号分析](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature)
  - [FST]
      - [ANGSD](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/FST%20using%20ANGSD)
      - [VCFTOOLS](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/Fst)
  - [XP-EHH](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/XP-EHH)
  - [XP-CLR](https://github.com/Crazzy-Rabbit/Script-in-Bio/blob/main/03.selection_signature/XP-CLR.sh)
  - [ln_πratio](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/ln_%CF%80ratio)
  - [CLR](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/SweeD_CLR)
  - [iHS](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/03.selection_signature/iHS)
  - [曼哈顿图](https://github.com/Crazzy-Rabbit/Script-in-Bio/blob/main/03.selection_signature/plot_Manhantan.R)
- [变异注释](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/04.Annoation)
  - [ANNOVAR](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/04.Annoation/Annovar)
  - [snpEff](https://github.com/Crazzy-Rabbit/Script-in-Bio/tree/main/04.Annoation/snpEff)
-[]
  
     
