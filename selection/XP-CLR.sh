# XP-CLR
# get sample
#!/bin/bash
beagle="/home/software/beagle.25Nov19.28d.jar"
bcftools="/home/sll/miniconda3/bin/bcftools"
vcftools="/home/sll/miniconda3/bin/vcftools"
xpclr="/home/sll/miniconda3/bin/xpclr"

# change as you want 
vcf="tibetan-36.filter-nchr.recode"            # big vcffile
allsmaple="allsample.txt"                      # ref and tag sample list to extract
ref.txt="refsample.txt"                        # ref sample list per row per ID
tag.txt="tagsample.txt"                        # tag sample list per row per ID

# extract sample 
$bcftools view -S $allsample.txt  ${vcf}.vcf  -Ov > allsample.vcf
echo "sample has been extracted from raw vcffile!"

mkdir XP-CLR.progress
cd XP-CLR.progress

for k in {1..29};

$vcftools --vcf ../allsample.vcf \
          --recode --recode-INFO-all \
          --chr ${k} \
          --out allsample.chr${k}
          
# calculate map distance                
$vcftools --vcf allsample.chr${k}.recode.vcf \
          --plink \
          --out chr${k}.MT
awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' chr${k}.MT.map > chr${k}.MT.map.distance
echo "map distance has been calculated"

# xpclr
xpclr --out chr${k} --format vcf \
      --input allsample.chr${k}.recode.vcf \
      --samplesA ref.txt \
      --samplesB tag.txt \
      --map chr${k}.MT.map.distance \
      --chr ${k} \
      --gdistkey None --phased \
      --size 50000 --step 50000

echo "XP-CLR has been finished!"

# merge
awk  '{print $2,$3,$4,$12,$13}'   Chr${k} > Chr${k}.ref_tag.chart.xpclr.50kb.windows;
cat ./*.ref_tag.chart.xpclr.50kb.windows > ../all.xpclr.50kb.windows

done

