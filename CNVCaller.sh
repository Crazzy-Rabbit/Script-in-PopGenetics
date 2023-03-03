
# 对基因组创建窗口文件（以后直接用即可）
perl /home/sll/miniconda3/CNVcaller/bin/CNVReferenceDB.pl /home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna -w 800
# 计算每个窗口的绝对拷贝数
ls *bam|cut -d"." -f 1 | sort -u | while read id; 
do bash /home/sll/miniconda3/CNVcaller/Individual.Process.sh -b `pwd`/${id}.sorted.addhead.markdup.bam -h ${id} -d /home/sll/miniconda3/CNVcaller/Btau5.0.1_800_link -s none; 
done

# 将referenceDB.800文件复制到RD_normalized目录下
cp referenceDB.800 RD_normalized

# 进入RD_normalized目录
cd RD_normalized

# 将RD_normalized目录下新生成的sex_1结尾的文件名，以绝对路径的形式写入list.txt中
ls -R `pwd`/*sex_1 > list.txt

# 新建exclude_list文件
touch exclude_list

# 拷贝数变异区域的确定
bash /home/sll/miniconda3/CNVcaller/CNV.Discovery.sh -l `pwd`/list.txt -e `pwd`/exclude_list -f 0.1 -h 1 -r 0.1 -p primaryCNVR -m mergeCNVR

# 基因型判定
python /home/sll/miniconda3/CNVcaller/Genotype.py --cnvfile mergeCNVR --outprefix genotypeCNVR --nproc 8
