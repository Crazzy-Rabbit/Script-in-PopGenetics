#!/bin/bash
# XP-CLR

vcftools="/home/sll/miniconda3/bin/vcftools"
xpclr="/home/sll/miniconda3/bin/xpclr"

if [ $# -ne 5 ]; then 
    echo "error.. need args"
    echo "command: bash $0 <vcf> <ref> <tag> <winsize> <step>"
    echo "vcf:     prefix of vcf file"
    echo "ref:     ref sample list per row per ID"
    echo "tag:     tag sample list per row per ID"
    echo "winsize: winsize for xpclr"
    echo "step:    step size for xpclr"
    exit 1
fi
vcf=$1            # big vcffile
ref=$2                            # ref sample list per row per ID
tag=$3                           # tag sample list per row per ID
winsize=$4                                  # winsize
step=$5                                    # stepsize

mkdir XP-CLR.progress
cd XP-CLR.progress
win=$((winsize/1000))  

for k in {1..29};
do
$vcftools --vcf ../${vcf}.vcf \
          --recode --recode-INFO-all \
          --chr ${k} \
          --out ${vcf}.chr${k}
          
# calculate map distance                
$vcftools --vcf ${vcf}.chr${k}.recode.vcf \
          --plink \
          --out chr${k}.MT
awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' chr${k}.MT.map > chr${k}.MT.map.distance
done 

for k in {1..29};
do
# xpclr
xpclr --out chr${k} --format vcf \
      --input ${vcf}.chr${k}.recode.vcf \
      --samplesA $ref \
      --samplesB $tag \
      --map chr${k}.MT.map.distance \
      --chr ${k} \
      --gdistkey None --phased \
      --size $winsize --step $stepsize

# merge
awk  '{print $2,$3,$4,$12,$13}'   Chr${k} > Chr${k}.ref_tag.chart.xpclr.${win}kb.windows
done

echo "XP-CLR has been finished!"

cat ./*.ref_tag.chart.xpclr.${win}kb.windows > ../all.xpclr.${win}kb.windows
