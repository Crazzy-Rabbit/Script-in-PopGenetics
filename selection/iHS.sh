#!/bin/bash
# iHS
beagle="/home/software/beagle.25Nov19.28d.jar"
vcftools="/home/sll/miniconda3/bin/vcftools"
selscan="/home/software/selscan/bin/linux/selscan"
norm="/home/software/selscan/bin/linux/norm"

function usage() {
    echo "从beagle 一直到最后标准化合并染色体，然后排序的过程"
    echo "Usage: bash $0 --vcf <vcf> --ne <ne> --win <winsize> --out <outprefix>"
    echo "required options"
      echo "-v|--vcf     vcf file"
      echo "-n|--ne      ne in beagle"
      echo "-w|--win     winsize in iHS"
      echo "-T|--thread  thread for selscan, default 10"
      echo "-o|--out     输出文件前缀"
      exit 1;
 }
 
 vcf=""
 ne=""
 win="50000"
 thread="10"
 out=""
 
 while [[ $# -gt 0 ]]
 do 
   case "$1" in 
     -v|--vcf )
       vcf=$2 ; shift2 ;;
     -n|--ne )
       ne=$2 ; shift2 ;;
     -w|--win )
       win=$2 ; shift2 ;;
     -T|--thread )
       thread=$2 ; shift2 ;;
     -o|--out )
       out=$2 ; shift2 ;;
     *) echo "输入参数不对哦！" >&2
        usage
        shift
        ;;
done

if [ -z $vcf ] || [ -z $ne ] || [ -z $out ]; then 
    echo "检查这些参数是否指定 --vcf --ne --out ！"
    usage
fi

function main() {
java -jar -Xmn12G -Xms24G -Xmx48G  $beagle \
                                   gt=${vcf} \
                                   out=${out}.beagle \
                                   ne=${ne}

mkdir iHS.progress
cd iHS.progress

for i in {1..29};
do 
# calculate map distance
$vcftools --gzvcf ../${out}.beagle.vcf.gz \
          --recode --recode-INFO-all \
          --chr ${i} \
          --out ${out}.chr${i}
$vcftools --vcf ${out}.chr${i}.recode.vcf \
          --plink \
          --out chr${i}.MT
          
awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' chr${i}.MT.map > chr${i}.MT.map.distance
done 

for i in {1..29};
do
# iHS
$selscan --ihs --vcf ${out}.chr${i}.recode.vcf \
               --map chr${i}.MT.map.distance \
               --threads $thread \
               --out  chr${i}.iHS

# chr
awk  '{print '${i}',$2,$3,$4,$5,$6}'  chr${i}.iHS.ihs.out > Chr${i}.ihs.out
sed -i 's/ /\t/g' Chr${i}.ihs.out

# add win and norm 
$norm --ihs --files  Chr${i}.ihs.out  \
            --bp-win --winsize $win

# extract result and merge
awk '{print '${i}',$1,$2,$4}' Chr${i}.norm.${out} > Chr${i}.chart.${out}
done

cat ./*.chart.${out} > ../${out}.ihs

# sort 
cd ..
sort -k 4n,4  ${out}.ihs > ${out}.ihs.sort
}
main
