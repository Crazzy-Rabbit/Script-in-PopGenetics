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
      echo "-o|--output   输出文件前缀"
      exit 1;
}

vcf=""
ne=""
ref=""
tag=""
win="50000"
thread="10"
output=""

while [[ $# -gt 0 ]];
do
  case "$1" in
    -v|--vcf )
        vcf=$2 ; shift2 ;;
    -n|--ne )
        ne=$2 ; shift2 ;;
    -r|--ref )
        ref=$2 ; shift2 ;;
    -t|--tag )
        tag=$2 ; shift2 ;;
    -w|--win )
        win=$2 ; shift2 ;;
    -T|--thread )
        thread=$2 ; shift2 ;;
    -o|--output )
        output=$2 ; shift2 ;;
    *) echo "Option error!" >&2
       usage
       shift
   esac
done

if [ -z $vcf ] || [ -z $ne ] || [ -z $ref ] || [ -z $tag ] || [ -z $output ]; then 
    echo "option --vcf --ne --ref --tag --output not specified !" >&2
    usage
fi

function main() {      
# beagle
java -jar -Xmn12G -Xms24G -Xmx48G  $beagle \
                                   gt=${vcf} \
                                   out=${output}.beagle \
                                   ne=${ne}

# extract sample
$bcftools view -S $ref  ${output}.beagle.vcf.gz  -Ov > ref.beagle.vcf
$bcftools view -S $tag  ${output}.beagle.vcf.gz  -Ov > tag.beagle.vcf

mkdir XP-EHH.progress
cd XP-EHH.progress

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
                 --threads $thread \
                 --out  chr${i}.ref_tag

# chr
awk  '{print '${i}',$2,$3,$4,$5,$6,$7,$8}'  chr${i}.ref_tag.xpehh.out > Chr${i}.ref_tag.xpehh.out
sed -i 's/ /\t/g' Chr${i}.ref_tag.xpehh.out            

# add win and norm
$norm --xpehh --files  Chr${i}.ref_tag.xpehh.out \
              --bp-win --winsize $win
              
# merge    
awk  '{print '${i}',$1,$2,$4,$5,$8,$9}'   Chr${i}.${output}.nochr > Chr${i}.${output}
done

cat ./*.${output} > ../${output}.xpehh
}
main
