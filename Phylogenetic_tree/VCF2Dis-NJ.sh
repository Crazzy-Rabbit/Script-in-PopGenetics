# VCF2Dis：
# 用于计算p-distance进而构建NJ进化树

VCF2Dis -InPut  <in.vcf>  -OutPut  <p_dis.mat>


# -InPut     <str>     Input one or muti GATK VCF genotype File
# -OutPut    <str>     OutPut Sample p-Distance matrix
# -InList    <str>     Input GATK muti-chr VCF Path List
# -SubPop    <str>     SubGroup SampleList of VCFFile [ALLsample]
# -Rand      <float>   Probability (0-1] for each site to join Calculation [1]
# -KeepMF              Keep the Middle File diff & Use matrix
# 结果文件用上传(ATGC: FastME)网页http://www.atgc-montpellier.fr/fastme/
# 选择数据类型Distance matrix
# 点击底部的run

# 3、后面下载下来压缩文件夹后，将.tree.nwk文件用ITOL打开即可
