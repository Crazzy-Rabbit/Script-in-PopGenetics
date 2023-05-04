#!/bin/bash
# iHS
beagle="/home/software/beagle.25Nov19.28d.jar"
vcftools="/home/sll/miniconda3/bin/vcftools"
selscan="/home/software/selscan/bin/linux/selscan"
norm="/home/software/selscan/bin/linux/norm"

function usage() {
    echo "从beagle 一直到最后标准化合并染色体，然后排序的过程"
    echo "Usage: bash $0 --vcf <vcf> --ne <ne> --win <winsize> --thread <thread> --out <outprefix>"
    echo "required options"
      echo "-v|--vcf     vcf file"
      echo "-n|--ne      ne in beagle"
      echo "-w|--win     winsize in iHS, default 50000"
      echo "-T|--thread  thread for selscan, default 10"
      echo "-c|--chr     最大染色体号，决定vcf文件分成多少个染色体文件"
      echo "-o|--out     输出文件前缀"
      exit 1;
 }
 
 vcf=""
 ne=""
 win="50000"
 thread="10"
 chr=""
 out=""
 
 while [[ $# -gt 0 ]]
 do 
   case "$1" in 
     -v|--vcf )
       vcf=$2 ; shift 2 ;;
     -n|--ne )
       ne=$2 ; shift 2 ;;
     -w|--win )
       win=$2 ; shift 2 ;;
     -T|--thread )
       thread=$2 ; shift 2 ;;
     -c|--chr )
       chr=$2 ; shift 2 ;;
     -o|--out )
       out=$2 ; shift 2 ;;
     *) echo "输入参数不对哦！"
        usage
        shift
        ;;
    esac
done

if [ -z $vcf ] || [ -z $ne ] || [ -z $out ]; then 
    echo "检查这些参数是否指定 --vcf --ne --out ！" >&2
    usage
fi

function main() {
java -jar -Xmn12G -Xms24G -Xmx48G  $beagle \
                                   gt=${vcf} \
                                   out=${out}.beagle \
                                   ne=${ne}

mkdir iHS.progress
cd iHS.progress

for ((i=1; i<=$chr; i++));
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

for ((i=1; i<=$chr; i++));
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
