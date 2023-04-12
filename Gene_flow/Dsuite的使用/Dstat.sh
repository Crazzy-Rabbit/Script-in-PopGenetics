export LD_LIBRARY_PATH=/home/sll/miniconda3/pkgs/libstdcxx-ng-12.1.0-ha89aaad_16/lib:$LD_LIBRARY_PATH
# 准备两列的表格，第一列为样本ID，第二列为群体ID(需指定外群Outgroup，也就是树的根)，想屏蔽的个体用第二列xxx表示，
# 注意群体ID不要包含“. - 空格”等字符，可以有下划线_ 否则，Fbranch会报错

# 1、Dsuite Dtrios模块：
# 为所有可能的种群/物种三重组合计算D和f4-ratio统计量（ABBA-BABA）
# 建议分染色体计算，然后使用DtriosCombine 模块将各染色体结果合并
/home/sll/software/Dsuite/Build/Dsuite Dtrios sample-select.vcf d.txt \
                                                                -t sample.ML.tree.treeout \
                                                                -o sample

# -t 物种树文件，可用treemix生成,根为outgroup，且m设为0，不考虑基因流
# -o sample：指定输出文件前缀，默认是sets
# -p 5：如果样品中包含pool-seq数据，-p用于设置最小深度，设置后从等位基因深度估计群体的等位基因频率。
# D和f4-ratio结果包含在.Dmin.txt文件中


# 2、DtriosCombine 模块对Dtrios结果合并：
/home/sll/software/Dsuite/Build/Dsuite DtriosCombine -t sample.ML.tree.treeout -o sample_all DminFile1.txt DminFile2.txt DminFile3.txt

# -o, --out-prefix=OUT_FILE_PREFIX       输出文件前缀，默认为 "out"
# -n, --run-name                         看不懂
# -t , --tree=TREE_FILE.nwk              树文件
# -s , --subset=start,length             只进行指定长度部分的合并


# 3、Dsuite Dinvestigate：
# 用于对感兴趣渗入组合的基因组区域的D值的计算，看哪些区域发生了渗入

/home/sll/software/Dsuite/Build/Dsuite Dinvestigate -w 50,25 INPUT_FILE.vcf.gz SETS.txt test_trios.txt

# Outputs D, f_d, f_dM, and d_f in genomic windows
# SETS.txt文件有两列 : SAMPLE_ID    POPULATION_ID
# test_trios.txt包含三个群体（除外群,外群在SETS.txt文件中已经指定）的名称:
# POP1   POP2    POP3
# There can be multiple lines and then the program generates multiple ouput files, named like POP1_POP2_POP3_localFstats_SIZE_STEP.txt

# -h, --help                              display this help and exit
# -w SIZE,STEP --window=SIZE,STEP         (required)设置移动的窗口及步长大小 (default: 50,25)
# -n, --run-name                          run-name will be included in the output file name
