# iHS
# beagle and get sample
#!/bin/bash
beagle="/home/software/beagle.25Nov19.28d.jar"
bcftools="/home/sll/miniconda3/bin/bcftools"
vcftools="/home/sll/miniconda3/bin/vcftools"
selscan="/home/software/selscan/bin/linux/selscan"
norm="/home/software/selscan/bin/linux/norm"

# change as you want 
vcf="tibetan-36.filter-nchr.recode"            # big vcffile
sample="your-sample.txt"                       # iHS sample list per row per ID
ne=36                                          # sample number
winsize=50000                                  # norm bin winsize
 
$bcftools view -S $sample  ${vcf}.vcf  -Ov > sample.vcf
echo "sample has been extracted from raw vcffile!"

java -jar -Xmn12G -Xms24G -Xmx48G  $beagle \
                                   gt=sample.vcf  \
                                   out=sample.beagle \
                                   ne=${ne}

echo "beagle has been finished!"
gunzip -d -c sample.beagle.vcf.gz > sample.beagle.vcf

mkdir iHS.progress
cd iHS.progress
win=$((winsize/1000))  

for i in {1..29};
do 
# calculate map distance
$vcftools --vcf ../sample.beagle.vcf \
          --recode --recode-INFO-all \
          --chr ${i} \
          --out sample.chr${i}
$vcftools --vcf sample.chr${i}.recode.vcf \
          --plink \
          --out chr${i}.MT
          
awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' chr${i}.MT.map > chr${i}.MT.map.distance

# iHS
$selscan --ihs --vcf sample.chr${i}.recode.vcf \
               --map chr${i}.MT.map.distance \
               --out  chr${i}.iHS

# chr
awk  '{print '${i}',$2,$3,$4,$5,$6}'  chr${i}.iHS.ihs.out > Chr${i}.ihs.out
sed -i 's/ /\t/g' Chr${i}.ihs.out

# add win and norm 
$norm --ihs --files  Chr${i}.ihs.out  \
            --bp-win --winsize $winsize

# extract result and merge
awk '{print '${i}',$1,$2,$4}' Chr${i}.ihs.out.100bins.norm.${win}kb.windows > Chr${i}.chart.ihs.out.${win}kb.windows
done
echo "iHS and norm has been finished"

cat ./*.chart.ihs.out.${win}kb.windows > ../all.ihs.out.${win}kb.windows

# sort 
cd ..
sort -k 4n,4  all.ihs.out.${win}kb.windows > all.ihs.out.${win}kb.windows.sort