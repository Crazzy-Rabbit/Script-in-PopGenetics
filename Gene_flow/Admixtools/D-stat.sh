# 1、AdmixTools需要特征（eigenstrat）文件，要将vcf文件转换为eigenstrat

bash convertVCFtoEigenstrat.sh QC.sample-select-geno005-maf003.vcf


# 2、修改文件

1、修改.ind文件的第三列为品种id
2、提供A、B、C、D群体的pop文件，4列
3、修改脚本文件par.PED.EIGENSTRAT.QC.sample-select-out-geno005-maf003，里的东西为：
genotypename:   QC.sample-select-out-geno005-maf003.eigenstratgeno
snpname:        QC.sample-select-out-geno005-maf003.snp
indivname:      QC.sample-select-out-geno005-maf003.ind
popfilename:    pop.txt
f4mode: NO  ##此选项为进行f4检验，默认是NO


# 3、qpDstat分析

qpDstat -p par.PED.EIGENSTRAT.QC.sample-select-out-geno005-maf003 > 4pop_admixtools

D统计量=0，说明总体ABBA和BABA的数量相同，不存在明显的渗入；如果不等于0，则或许存在渗入。
Z=D/ standard_error
Z>3和<-3分别是正负显著
也就是用于判断X,Y与W之间是否发生基因流
