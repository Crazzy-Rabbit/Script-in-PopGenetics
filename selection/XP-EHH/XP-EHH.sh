#!/bin/bash

# XP-EHH
# beagle and get sample
beagle="/home/software/beagle.25Nov19.28d.jar"
bcftools="/home/sll/miniconda3/bin/bcftools"
vcftools="/home/sll/miniconda3/bin/vcftools"
selscan="/home/software/selscan/bin/linux/selscan"
norm="/home/software/selscan/bin/linux/norm"

function usage() {
    echo "Usage: bash $0 --vcf <vcf> --ne <ne> --ref <ref> --tag <tag> --win <winsize> --thread <thread> --output <outprefix>"
    echo "required options"
      echo "-v|--vcf      vcf file"
      echo "-n|--ne       ne was ne number in beagle"
      echo "-r|--ref      ref sample per row per ID"
      echo "-t|--tag      tag sample per row per ID"
      echo "-w|--win      winsize in xpehh, default 50000"
      echo "-T|--thread   threads, default 10"
      echo "-c|--chr      最大染色体号，决定你的vcf文件分多少个染色体文件"
      echo "-o|--output   输出文件前缀"
      exit 1;
}

vcf=""
ne=""
ref=""
tag=""
win="50000"
thread="10"
chr=""
output=""

while [[ $# -gt 0 ]];
do
  case "$1" in
    -v|--vcf )
        vcf=$2 ; shift 2 ;;
    -n|--ne )
        ne=$2 ; shift 2 ;;
    -r|--ref )
        ref=$2 ; shift 2 ;;
    -t|--tag )
        tag=$2 ; shift 2 ;;
    -w|--win )
        win=$2 ; shift 2 ;;
    -T|--thread )
        thread=$2 ; shift 2 ;;
    -c|--chr )
        chr=$2 ; shift 2 ;;
    -o|--output )
        output=$2 ; shift 2 ;;
    *) echo "输入参数不对哦!" >&2
       usage
       shift
   esac
done

if [ -z $vcf ] || [ -z $ne ] || [ -z $ref ] || [ -z $tag ] || [ -z $output ]; then 
    echo "检查一下这几个参数输了没 --vcf --ne --ref --tag --output !" >&2
    usage
fi

function main() {      
# beagle
java -jar -Xmn12G -Xms24G -Xmx48G  $beagle gt=${vcf} out=${output}.beagle ne=${ne}

#extract sample
$bcftools view -S $ref  ${output}.beagle.vcf.gz  -Ov > ref.beagle.vcf
$bcftools view -S $tag  ${output}.beagle.vcf.gz  -Ov > tag.beagle.vcf

mkdir XP-EHH.progress
cd XP-EHH.progress

for ((k=1; k<=$chr; k++));
do 
#splite chr for ref and tag
$vcftools --vcf ../ref.beagle.vcf --recode --recode-INFO-all --chr ${k} --out ref.chr${k}
$vcftools --vcf ../tag.beagle.vcf --recode --recode-INFO-all --chr ${k} --out tag.chr${k}        
#calculate map distance                
$vcftools --vcf ref.chr${k}.recode.vcf --plink --out chr${k}.MT
awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' chr${k}.MT.map > chr${k}.MT.map.distance
done

for ((k=1; k<=$chr; k++));
do
#XP-EHH
$selscan --xpehh --vcf tag.chr${k}.recode.vcf --vcf-ref ref.chr${k}.recode.vcf --map chr${k}.MT.map.distance --threads $thread --out  chr${k}.ref_tag          
#norm
$norm --xpehh --files  Chr${k}.ref_tag.xpehh.out --bp-win --winsize $win              
done
# 输出文件为.100bins.norm格式的文件，用perl脚本加窗口步长。暂时先这样，之后再加循环
}
main
