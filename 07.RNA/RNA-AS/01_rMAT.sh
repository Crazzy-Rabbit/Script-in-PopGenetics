rmats.py --b1 b1.txt \
         --b2 b2.txt \
         --gtf /home/sll/genome-sheep/Oar_rambouillet_v1.0-ncbi/GCF_002742125.1_Oar_rambouillet_v1.0_genomic.gtf \
         --od AS --tmp tmp -t paired \
         --readLength 150 --cstat 0.0001 --nthread 10

# --b1 b1.txt 输入sample1的txt格式的文件，文件内以逗号分隔重复样本的bam文件名
# --b2 b2.txt 输入sample2的txt格式的文件，文件内以逗号分隔重复样本的bam文件名
# -t readType 双端测序则readType为paired，单端测序则为single
# --readLength 测序reads的长度,可以从质控报告看
# --gtf gtfFile 需要输入的gtf文件
# --od outDir 所有输出文件的路径（文件夹）
# --nthread 设置线程数
# --cstat The cutoff splicing difference. The cutoff used in the null hypothesis test for differential splicing
# --statoff，进行单样本或者是单组的分析，并跳过统计分析
