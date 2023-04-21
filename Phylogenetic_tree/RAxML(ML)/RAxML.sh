#! /bin/bash
#! /bin/bash

if [ $# -ne 4 ]; then
    echo "error.. need args"
    echo "command: $0 <Input file [vcffile]> <Outgroup> <Prefix of output> <Threads [number]>"
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
