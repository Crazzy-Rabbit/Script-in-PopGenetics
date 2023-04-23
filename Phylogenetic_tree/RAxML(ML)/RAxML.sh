#! /bin/bash
#! /bin/bash

if [ $# -ne 4 ]; then
    echo "command:  $0 <vcf> <Outgroup> <output> <Threads>"
    echo "vcf:      vcf文件"
    echo "Outgroup: 外群名称，或是外群那个个体ID"
    echo "output:   输出文件前缀"
    echo "Threads:  线程数，一般可设置为30"
    echo "命令默认为bootstrap 100次，可通过对 -# 指令修改二改变次数"
    exit 1
fi
vcf=$1
outgroup=$2
prefix=$3
threads=$4

# 1、转为phy格式：
python /home/sll/software/vcf2phylip.py --input $vcf --output-prefix $prefix
# 2、建树：
raxmlHPC-PTHREADS-SSE3 -f a -m GTRGAMMA -p 23 -x 123 -# 100 -s ${prefix}.min4.phy -n $prefix -T $threads -o $outgroup
