#### CNVcaller的循环流程
##### 请注意，其中提供的文件等建议均提供绝对路径
##### 01 和 02 步的 win 大小需一致
##### 01 的link文件和 02的窗口文件可以一直用，若物种不变
##### 01.使用参考基因组生成dup.link窗口文件
```
bash 01_DupfiletoCNVCaller.sh

# 窗口大小推荐： >10x使用400-1000，<10x使用1000
```
##### 02.计算窗口文件
02_01CalWinFile.sh
```
#! /bin/bash
## author: Shill
## Create a window file for the genome (you can use it directly later)                                      
CNVReferenceDB="/home/sll/miniconda3/CNVcaller/bin/CNVReferenceDB.pl"
genomicfa="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna"
winsize=1000

perl $CNVReferenceDB $genomicfa -w $winsize
```
##### 03.计算每个个体绝对拷贝数
02_02CalAbsoluteCN.sh
```
#! /bin/bash
## cal absolute copy number
IndividualProcess="/home/sll/miniconda3/CNVcaller/Individual.Process.sh"
Winlink="/home/sll/genome-cattle/CNVCaller-Duplink/ARS_UCD1.2_1000_link"

ls *markdup.bam|cut -d"." -f 1 | sort -u | while read id;
do
    bash $IndividualProcess -b `pwd`/${id}.sorted.addhead.markdup.bam -h $id -d $Winlink -s none;
done 
```
##### 04.群体水平定义CNVR的边界
bash 03_01DeterminCNVR.sh
```
#! /bin/bash
## determin the CNVR 
CNVDiscoverysh="/home/sll/miniconda3/CNVcaller/CNV.Discovery.sh"

cp referenceDB.1000 RD_normalized
cd RD_normalized
ls -R `pwd`/*sex_1 > list.txt
touch exclude_list

bash $CNVDiscoverysh -l `pwd`/list.txt -e `pwd`/exclude_list -f 0.1 -h 3 -r 0.5 -p primaryCNVR -m mergeCNVR

# -f  在一个拷贝数窗口中这一类型拷贝数的最小频率
# -h  定义拷贝数窗口时，同类型的拷贝数个体大于这个数，则为这一类拷贝数窗口
# -r （两个非重叠窗口K间的最小泊松相关系数）0.5 样本量在30个以内； 0.4 样本量在30-50； 0.3 样本量在50-100； 0.2 样本量在100-200
```
##### 05.使用混合高斯模型确定CNVR的genotype
bash 03_02GenotypeCNVR.sh
```
#! /bin/bash
## genotype for CNVR
Genotypepy="/home/sll/miniconda3/CNVcaller/Genotype.py"
python="/home/sll/miniconda3/bin/python3.9"

$python $Genotypepy --cnvfile mergeCNVR --outprefix genotypeCNVR --nproc 8
```
