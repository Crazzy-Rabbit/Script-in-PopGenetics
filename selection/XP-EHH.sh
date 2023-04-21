#!/bin/bash

# XP-EHH
# beagle and get sample
beagle="/home/software/beagle.25Nov19.28d.jar"
bcftools="/home/sll/miniconda3/bin/bcftools"
vcftools="/home/sll/miniconda3/bin/vcftools"
selscan="/home/software/selscan/bin/linux/selscan"
norm="/home/software/selscan/bin/linux/norm"

if [ $# -ne 5 ]; then
    echo "error.. need args"
    echo "command:  bash $0 <vcf> <ne> <ref> <tag> <winsize>"
    echo "vcf:      Prefix of vcf file"
    echo "ne:       ne was ne number in beagle"
    echo "ref:      ref sample per row per ID"
    echo "tag:      tag sample per row per ID"
    echo "winsize:  winsize in xpehh"
    exit 1
fi
vcf=$1                                         # big vcffile
ne=$2                                         # sample number
ref=$3                                        # ref sample list per row per ID
tag=$4                                        # tag sample list per row per ID
winsize=$5                                    # norm bin winsize

# beagle
java -jar -Xmn12G -Xms24G -Xmx48G  $beagle \
                                   gt=${vcf}.vcf  \
                                   out=${vcf}.beagle \
                                   ne=${ne}
echo "beagle has been finished!"

# extract sample
$bcftools view -S $ref  ${vcf}.beagle.vcf.gz  -Ov > ref.beagle.vcf
$bcftools view -S $tag  ${vcf}.beagle.vcf.gz  -Ov > tag.beagle.vcf
echo "sample has been extracted from raw vcffile!"

mkdir XP-EHH.progress
cd XP-EHH.progress
win=$((winsize/1000))  

for i in {1..29};
do 
# splite chr for ref and tag
$vcftools --vcf ../ref.beagle.vcf \
          --recode --recode-INFO-all \
          --chr ${i} \
          --out ref.chr${i}
$vcftools --vcf ../tag.beagle.vcf \
          --recode --recode-INFO-all \
          --chr ${i} \
          --out tag.chr${i}
          
# calculate map distance                
$vcftools --vcf ref.chr${i}.recode.vcf \
          --plink \
          --out chr${i}.MT
awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' chr${i}.MT.map > chr${i}.MT.map.distance
done

for i in {1..29};
do
# XP-EHH
$selscan --xpehh --vcf tag.chr${i}.recode.vcf \
                 --vcf-ref ref.chr${i}.recode.vcf \
                 --map chr${i}.MT.map.distance \
                 --threads 10 \
                 --out  chr${i}.ref_tag

# chr
awk  '{print '${i}',$2,$3,$4,$5,$6,$7,$8}'  chr${i}.ref_tag.xpehh.out > Chr${i}.ref_tag.xpehh.out
sed -i 's/ /\t/g' Chr${i}.ref_tag.xpehh.out            

# add win and norm
$norm --xpehh --files  Chr${i}.ref_tag.xpehh.out \
              --bp-win --winsize $winsize
              
# merge    
awk  '{print '${i}',$1,$2,$4,$5,$8,$9}'   Chr${i}.ref_tag.xpehh.out.norm.${win}kb.windows > Chr${i}.ref_tag.chart.xpehh.out.norm.${win}kb.windows
done  
echo "XP-EHH has been finished!"


cat ./*.ref_tag.chart.xpehh.out.norm.${win}kb.windows > ../all.xpehh.out.norm.${win}kb.windows

    
