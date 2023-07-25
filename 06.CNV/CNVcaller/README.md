#### `CNVcaller`的循环流程
##### 请注意，其中提供的文件等建议均提供绝对路径
##### 01 和 02 步的 win 大小需一致
##### 01 的`link`文件和 02的窗口文件可以一直用，若物种不变
##### 01.使用参考基因组生成`dup.link`窗口文件
```
bash 01_DupfiletoCNVCaller.sh

# 窗口大小推荐： >10x使用800，20X 左右用400， 50X 左右用200   <10x使用1000
```
##### 02.计算窗口文件
`02_01CalWinFile.sh`
```
#! /bin/bash
## author: Shill
## Create a window file for the genome (you can use it directly later)                                      
CNVReferenceDB="/home/sll/miniconda3/CNVcaller/bin/CNVReferenceDB.pl"
genomicfa="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna"
winsize=1000

perl $CNVReferenceDB $genomicfa -w $winsize
```
```
-w 滑动窗口大小（bp）。默认 800。注：对于≥10X 的测序数据，我们推荐用 400-1,000 bp的窗口大小，对于<10X 的测序数据我们推荐用 1,000-2,000 bp 的窗口大小。增大窗口可以降低假阳性率，但同时会增加假阴性率。
-l 窗口可含有的最低 GC 比例，低于该比例的窗口将不会进入后续计算。默认 0.2。
-u 窗口可含有的最高 GC 比例，高于该比例的窗口将不会进入后续计算。默认 0.7。注：一般动植物基因组中 GC 比例低于 20%和高于 70%的窗口数量较少，而且目前二代测序较难测到这些区域，故这类窗口不建议进入统计。
-g 窗口可含有的最高 gap 比例，高于该比例的窗口将不会进入后续计算。默认 0.5。注：当一个窗口存在任意比例的 gap，都意味着 gap 两侧的序列可能存在组装错误，所以建议不对这类窗口进行统计计算。如果参考基因组 gap 数量过多（如 N50 小于 20Kb，也就是大约每20 Kb 会有一个 gap），导致不进入统计的窗口数超过全基因组的 5%，可以适当将 gap 比例参数设置为 0.1。
```
##### 03.计算每个个体绝对拷贝数
`02_02CalAbsoluteCN.sh`
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
如果你的bam文件有.1什么的带.的SRR号，那么用下面脚本
```
#! /bin/bash
## cal absolute copy number
IndividualProcess="/home/sll/miniconda3/CNVcaller/Individual.Process.sh"               #change as you want
Winlink="/home/sll/genome-cattle/CNVCaller-Duplink/ARS_UCD1.2_1000_link"               #dup file that you have created use blasr, change as you want
sample_list="sample_list.txt"                                                          #per row per ID

cat $sample_list | while read -r sample;
do
    echo $sample
    bash $IndividualProcess -b `pwd`/${sample}.sorted.addhead.markdup.bam -h $sample -d $Winlink -s none;
done
```
```
-b BWA 比对生成的 BAM 文件。
-h BAM 文件的标头信息，需要与 BAM 文件中 SM 标签保持一致（用户可以通过 samtoolsview -H BAM 查看）。
-d 校 正 所 需要的 link 文 件。
-s none   一般设为none，除非你想研究性染色体
```
##### 04.群体水平定义CNVR的边界
`bash 03_01DeterminCNVR.sh`
```
#! /bin/bash
## determin the CNVR 
CNVDiscoverysh="/home/sll/miniconda3/CNVcaller/CNV.Discovery.sh"

cp referenceDB.1000 RD_normalized
cd RD_normalized
ls -R `pwd`/*sex_1 > list.txt
touch exclude_list

bash $CNVDiscoverysh -l `pwd`/list.txt -e `pwd`/exclude_list -f 0.1 -h 3 -r 0.5 -p primaryCNVR -m mergeCNVR

# -e 位于该列表的样本不用于检测CNVR，这个选项适用于外群或者低质量的珍贵样本
# -f  在一个拷贝数窗口中这一类型拷贝数的最小频率
# -h  定义拷贝数窗口时，同类型的拷贝数个体大于这个数，则为这一类拷贝数窗口， 注：在定义候选拷贝数变异窗口时只需要满足-f 与-h 中的任意一个即可。
# -r （两个非重叠窗口K间的最小泊松相关系数）0.5 样本量在30个以内； 0.4 样本量在30-50； 0.3 样本量在50-100； 0.2 样本量在100-200
```
##### 05.使用混合高斯模型确定CNVR的genotype
`bash 03_02GenotypeCNVR.sh`
```
#! /bin/bash
## genotype for CNVR
Genotypepy="/home/sll/miniconda3/CNVcaller/Genotype.py"
python="/home/sll/miniconda3/bin/python3.9"

$python $Genotypepy --cnvfile mergeCNVR --outprefix genotypeCNVR --nproc 1

# --nproc 进程数，一个占据200%的CPU，这边建议设置1就够了，服务器够大可考虑加多
# --merge 为了得到更多的双等位 CNVR 用于后续分析，可以使用--merge 选项。使用后，会增加一个后缀为 _merge.vcf 的 输 出 文 件 ， 类 似 <outprefix>.vcf 文 件 ， 区 别 在 于
<outprefix>_merge.vcf 中把所有重复算作一种变异类型，这样就可以进行PCA这些了
```

##### `GetSVtypeForIntersect.py`脚本提取`SVtype`，方便使用`smoove`结果进行矫正
```
python3 GetSVtypeForIntersect.py --vcffile genotypeCNVR.vcf --out CNVcaller_svtype.txt
```
注：只对DEL进行矫正，因为LUMPY软件对DEL的检测精度和准确度很高，但是对DUP的差强人意
```
# 用的是bedtools,一般是0.3的占比
bedtools intersect -a genotypeCNVR_merge.DEL -b smoove_svpos.DEL -f 0.3 -F 0.3 -e -wa > CNVcaller_smoove.DEL

# 这样的结果会有很多重复区间，用我的脚本去去重
python Del-overlap_interval.py -i CNVcaller_smoove.DEL -o CNVcaller_smoove.nonoverlap.DEL
```

