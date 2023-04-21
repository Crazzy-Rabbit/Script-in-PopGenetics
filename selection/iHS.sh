# iHS
# beagle and get sample
#!/bin/bash
beagle="/home/software/beagle.25Nov19.28d.jar"
vcftools="/home/sll/miniconda3/bin/vcftools"
selscan="/home/software/selscan/bin/linux/selscan"
norm="/home/software/selscan/bin/linux/norm"

if [$# -ne 3]; then
    echo "command: bash $0 <vcf> <ne> <winsize>"
    echo "vcf:     prefix of vcf file"
    echo "ne:      ne in beagle"
    echo "winsize: winsize in iHS"
    exit 1
fi
vcf=$1           
ne=$2                                       
winsize=$3
 
java -jar -Xmn12G -Xms24G -Xmx48G  $beagle \
                                   gt=${vcf}.vcf  \
                                   out=${vcf}.beagle \
                                   ne=${ne}

echo "beagle has been finished!"

mkdir iHS.progress
cd iHS.progress
win=$((winsize/1000))  

for i in {1..29};
do 
# calculate map distance
$vcftools --gzvcf ../${vcf}.beagle.vcf.gz \
          --recode --recode-INFO-all \
          --chr ${i} \
          --out ${vcf}.chr${i}
$vcftools --vcf ${vcf}.chr${i}.recode.vcf \
          --plink \
          --out chr${i}.MT
          
awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' chr${i}.MT.map > chr${i}.MT.map.distance
done 

for i in {1..29};
do
# iHS
$selscan --ihs --vcf ${vcf}.chr${i}.recode.vcf \
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
