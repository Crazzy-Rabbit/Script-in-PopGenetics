#!/bin/bash
# XP-CLR

vcftools="/home/sll/miniconda3/bin/vcftools"
xpclr="/home/sll/miniconda3/bin/xpclr"

function usage() {
    echo "Usage: bash $0 --vcf <vcf> --ref <ref> --tag <tag> --win <winsize> --step <step> --out <outprefix>"
    echo "required options"
      echo "-v|--vcf     vcf file"
      echo "-r|--ref     ref sample list per row per ID"
      echo "-t|--tag     tag sample list per row per ID"
      echo "-w|--win     winsize for xpclr, default 50000"
      echo "-s|--step    step size for xpclr, default 25000"
      echo "-o|--out     输出文件前缀"
      exit 1;
}

vcf=""
ref=""
tag=""
win="50000"
step="25000"
out=""

while [[ $# -gt 0 ]]
do
  case "$1" in
    -v|--vcf )
        vcf=$2 ; shift2 ;;
    -r|--ref )
        ref=$2 ; shift2 ;;
    -t|--tag )
        tag=$2 ; shift2 ;;
    -w|--win )
        win=$2 ; shift2 ;;
    -s|--step )
        step=$2 ; shift2 ;;
    -o|--out )
        out=$2 ; shift2 ;;
    *) echo "输入参数不对哦!" ;
        usage
        shift
        ;;
  esac
done

if [ -z $vcf ] || [ -z $ref ] || [ -z $tag ] || [ -z $out ]; then
    echo "检查下这些参数指定没有 --vcf and --ref and --tag and --out ！" >&2
    usage
fi
        
function main {
mkdir XP-CLR.progress
cd XP-CLR.progress

for k in {1..29};
do
$vcftools --vcf ../$vcf \
          --recode --recode-INFO-all \
          --chr ${k} \
          --out ${out}.chr${k}
          
# calculate map distance                
$vcftools --vcf ${out}.chr${k}.recode.vcf \
          --plink \
          --out chr${k}.MT
awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' chr${k}.MT.map > chr${k}.MT.map.distance
done 

for k in {1..29};
do
# xpclr
xpclr --out chr${k} --format vcf \
      --input ${out}.chr${k}.recode.vcf \
      --samplesA $ref \
      --samplesB $tag \
      --map chr${k}.MT.map.distance \
      --chr ${k} \
      --gdistkey None --phased \
      --size $win \
      --step $step

# merge
awk  '{print $2,$3,$4,$12,$13}'   Chr${k} > Chr${k}.${out}
done

cat ./*.${out} > ../${out}.xpclr
}
main
