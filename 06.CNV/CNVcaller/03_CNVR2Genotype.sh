# Set up the file name(obtain the absolute paths), software                                             

CNVDiscoverysh="/home/sll/miniconda3/CNVcaller/CNV.Discovery.sh"                         #change as you want
Genotypepy="/home/sll/miniconda3/CNVcaller/Genotype.py"                                  #change as you want
python="/home/sll/miniconda3/bin/python3.9"


cp referenceDB.${winsize} RD_normalized
cd RD_normalized
ls -R `pwd`/*sex_1 > list.txt
touch exclude_list

# Determin the CNV region
bash $CNVDiscoverysh -l `pwd`/list.txt -e `pwd`/exclude_list -f 0.1 -h 3 -r 0.5 -p primaryCNVR -m mergeCNVR

# -f  在一个拷贝数窗口中这一类型拷贝数的最小频率
# -h  定义拷贝数窗口时，同类型的拷贝数个体大于这个数，则为这一类拷贝数窗口
# -r （两个非重叠窗口K间的最小泊松相关系数）0.5 样本量在30个以内； 0.4 样本量在30-50； 0.3 样本量在50-100； 0.2 样本量在100-200


# Genotype determination
$python $Genotypepy --cnvfile mergeCNVR --outprefix genotypeCNVR --nproc 8
echo "Congratulation!CNVCaller has finished now!"
