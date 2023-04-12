# 1、AdmixTools需要特征（eigenstrat）文件，要将vcf文件转换为eigenstrat

bash convertVCFtoEigenstrat.sh QC.sample-select-geno005-maf003.vcf


# 2、文件及运算脚本修改

1、修改.ind文件的第三列为品种id
2、提供A、B、C群体的pop文件，3列（outgroup f3时，C为外群，判断A和B的关系）
3、修改脚本文件par.PED.EIGENSTRAT.QC.sample-select-out-geno005-maf003，里的东西为：
genotypename:   QC.sample-select-out-geno005-maf003.eigenstratgeno
snpname:        QC.sample-select-out-geno005-maf003.snp
indivname:      QC.sample-select-out-geno005-maf003.ind
popfilename:    pop.txt
inbreed: YES ##(做outgroup f3应删除这一行，目标群体存在近交，则加上这行)


# 3、 admixtools中的qp3Pop进行f3统计

qp3Pop -p par.PED.EIGENSTRAT.QC.sample-select-out-geno005-maf003 > 3pop_qp3pop
