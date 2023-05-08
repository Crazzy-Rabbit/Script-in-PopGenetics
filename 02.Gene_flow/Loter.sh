#!/bin/sh

sample.txt="yoursample.txt"


# 转换为npy格式
ls *.vcf |cut -d '.' -f -1| while read id;
do
python /home/sll/21-24.script/vcf2npy.py --vcffile ${id}.vcf --samplelist $sample.txt --outprefix ${id}.npy;
done


# 运行loter
loter_cli -r ref_phase.npy -a admix_phase.npy -f npy -pc -o interval.txt

#对loter结果进行转置
awk '{for(i=1;i<=NF;i++)a[NR,i]=$i}END{for(j=1;j<=NF;j++)for(k=1;k<=NR;k++)printf k==NR?a[k,j] RS:a[k,j] FS}' interval.txt > zhuanzhi_interval.txt

#paste合并位置与转置后的文件
paste posfile.txt zhuanzhi_interval.txt > 1_loter_out.txt

#加上头文件
#先这样吧
